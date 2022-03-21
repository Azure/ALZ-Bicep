targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param parAssignableScopeManagementGroupId string

var varRole = {
  name: 'Subscription owner'
  description: 'Delegated role for subscription owner derived from subscription Owner role'
}

resource resRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(varRole.name)
  properties: {
    roleName: varRole.name
    description: varRole.description
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/*/write'
          'Microsoft.Network/vpnGateways/*'
          'Microsoft.Network/expressRouteCircuits/*'
          'Microsoft.Network/routeTables/write'
          'Microsoft.Network/vpnSites/*'
        ]
        dataActions: []
        notDataActions: []
      }
    ]
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', parAssignableScopeManagementGroupId)
    ]
  }
}

output outRoleDefinitionId string = resRoleDefinition.id
