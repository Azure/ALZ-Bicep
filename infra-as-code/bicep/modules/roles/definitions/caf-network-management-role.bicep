targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group id will be used for the assignableScopes property in the role definition.')
param parAssignableScopeManagementGroupId string

var varRole = {
  name: 'Network management (NetOps)'
  description: 'Platform-wide global connectivity management: Virtual networks, UDRs, NSGs, NVAs, VPN, Azure ExpressRoute, and others'
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
          '*/read'
          'Microsoft.Network/*'
          'Microsoft.Resources/deployments/*'
          'Microsoft.Support/*'
        ]
        notActions: []
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
