targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.')
param parAssignableScopeManagementGroupId string

var varRole = {
  name: 'Application owners (DevOps/AppOps)'
  description: 'Contributor role granted for application/operations team at resource group level'
}

resource resRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(varRole.name)
  scope: managementGroup()
  properties: {
    roleName: varRole.name
    description: varRole.description
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/*/write'
          'Microsoft.Network/publicIPAddresses/write'
          'Microsoft.Network/virtualNetworks/write'
          'Microsoft.KeyVault/locations/deletedVaults/purge/action'
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
