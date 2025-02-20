targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Custom Role Definitions'
metadata description = 'Custom Role Definitions for ALZ Bicep'

type typCustomRole = {
  @description('Name of the custom role')
  @minLength(5)
  name: string

  @description('Description of the custom role')
  @minLength(5)
  description: string?

  @description('Control plane actions that the role allows')
  actions: string[]

  @description('Control plane actions that are excluded from the allowed actions')
  notActions: string[]?

  @description('Data plane actions that the role allows')
  dataActions: string[]?

  @description('Data plane actions that are excluded from the allowed actions')
  notDataActions: string[]?

  @description('Scopes that the custom role is available for assignment')
  assignableScopes: string[]?
}

@sys.description('The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.')
param parAssignableScopeManagementGroupId string = 'alz'

@sys.description('Additional role to create')
param parAdditionalRoles typCustomRole[] = [
  {
    name: '[alz] IP address writer'
    actions: [
      'Microsoft.Network/publicIPAddresses/write'
    ]
  }
  {
    name: '[alz] JIT Contributor'
    description: 'Configure or edit a JIT policy for VMs'
    actions: [
      'Microsoft.Security/locations/jitNetworkAccessPolicies/write'
      'Microsoft.Compute/virtualMachines/write'
      'Microsoft.Security/locations/jitNetworkAccessPolicies/read'
      'Microsoft.Security/locations/jitNetworkAccessPolicies/initiate/action'
      'Microsoft.Security/policies/read'
      'Microsoft.Security/pricings/read'
      'Microsoft.Compute/virtualMachines/read'
      'Microsoft.Network/*/read'
    ]
  }
]

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '032d0904-3d50-45ef-a6c1-baa9d82e23ff'

module modRolesSubscriptionOwnerRole 'definitions/cafSubscriptionOwnerRole.bicep' = {
  name: 'deploy-subscription-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesApplicationOwnerRole 'definitions/cafApplicationOwnerRole.bicep' = {
  name: 'deploy-application-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesNetworkManagementRole 'definitions/cafNetworkManagementRole.bicep' = {
  name: 'deploy-network-management-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesSecurityOperationsRole 'definitions/cafSecurityOperationsRole.bicep' = {
  name: 'deploy-security-operations-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

resource resAdditionalRoles 'Microsoft.Authorization/roleDefinitions@2022-04-01' = [for role in parAdditionalRoles: {
  name: guid(role.name, parAssignableScopeManagementGroupId)
  properties: {
    roleName: role.name
    description: role.?description ?? null
    type: 'CustomRole'
    permissions: [
      {
        actions: role.actions
        notActions: role.?notActions ?? null
        dataActions: role.?dataActions ?? null
        notDataActions: role.?notDataActions ?? null
      }
    ]
    assignableScopes: role.?assignableScopes ?? [
      tenantResourceId('Microsoft.Management/managementGroups', parAssignableScopeManagementGroupId)
    ]
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

output outRolesSubscriptionOwnerRoleId string = modRolesSubscriptionOwnerRole.outputs.outRoleDefinitionId
output outRolesApplicationOwnerRoleId string = modRolesApplicationOwnerRole.outputs.outRoleDefinitionId
output outRolesNetworkManagementRoleId string = modRolesNetworkManagementRole.outputs.outRoleDefinitionId
output outRolesSecurityOperationsRoleId string = modRolesSecurityOperationsRole.outputs.outRoleDefinitionId
