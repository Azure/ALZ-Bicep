targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to a Management Group'
metadata description = 'Module to assign a role to a Management Group'

@sys.description('GUID for the role assignment name.')
param parRoleAssignmentNameGuid string = guid(managementGroup().name, parRoleDefinitionId, parAssigneeObjectId)

@sys.description('Role Definition Id (e.g., Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@sys.description('Principal type of the assignee: \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal/Managed Identity).')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@sys.description('Object ID of groups, service principals, or managed identities (use principal ID for managed identities).')
param parAssigneeObjectId string

@sys.description('Set to true to opt out of deployment telemetry.')
param parTelemetryOptOut bool = false

@sys.description('Role assignment condition (e.g., Owner, User Access Administrator). Only roles with `write` or `delete` permissions can have a condition.')
param parRoleAssignmentCondition string = ''

@sys.description('Role assignment condition version. Only value accepted is \'2.0\'.')
param parRoleAssignmentConditionVersion string = '2.0'

// Customer Usage Attribution Id
var varCuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

resource resRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: parRoleAssignmentNameGuid
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', parRoleDefinitionId)
    principalId: parAssigneeObjectId
    principalType: parAssigneePrincipalType
    condition: !empty(parRoleAssignmentCondition) ? parRoleAssignmentCondition : null
    conditionVersion: !empty(parRoleAssignmentCondition) ? parRoleAssignmentConditionVersion : null
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location, parRoleAssignmentNameGuid)}'
  params: {}
}
