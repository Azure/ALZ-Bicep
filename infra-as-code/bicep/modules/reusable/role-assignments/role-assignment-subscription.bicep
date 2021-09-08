targetScope = 'subscription'

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@description('Principal type of the assignee.  Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Servince Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@description('Object Id of groups, service principals or  managed identities. For managed identities use the principal id. For service principals, use the object id and not the app id')
param parAssigneeObjectId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(subscription().id, parRoleDefinitionId, parAssigneeObjectId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', parRoleDefinitionId)
    principalId: parAssigneeObjectId
    principalType: parAssigneePrincipalType
  }
}
