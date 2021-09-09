targetScope = 'managementGroup'

@description('A list of management group scopes that will be used for role assignment (i.e. [alz-platform-connectivity, alz-platform-identity]).  Default = []')
param parManagementGroupScopes array = []

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

module modRoleAssignment 'role-assignment-management-group.bicep' = [for managementGroupScope in parManagementGroupScopes: {
  name: 'rbac-assign-${uniqueString(managementGroupScope, parAssigneeObjectId)}'
  scope: managementGroup(managementGroupScope)
  params: {
    parRoleAssignmentNameGuid: guid(managementGroupScope, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
  }
}]
