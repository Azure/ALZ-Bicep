/*
SUMMARY: Role Assignments for 1 or more Management Groups
DESCRIPTION:
  Module provides role assignment capabilities for Management Groups.  The role assignments can be performed for:

  * Managed Identities (System and User Assigned)
  * Service Principals
  * Security Groups

AUTHOR/S: SenthuranSivananthan, jtracey93
VERSION: 1.1.0
*/
targetScope = 'managementGroup'

@description('A list of management group scopes that will be used for role assignment (i.e. [alz-platform-connectivity, alz-platform-identity]).  Default = []')
param parManagementGroupIds array = []

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@description('Principal type of the assignee.  Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param parAssigneeObjectId string

module modRoleAssignment 'roleAssignmentManagementGroup.bicep' = [for parManagementGroupId in parManagementGroupIds: {
  name: 'rbac-assign-${uniqueString(parManagementGroupId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: managementGroup(parManagementGroupId)
  params: {
    parRoleAssignmentNameGuid: guid(parManagementGroupId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
  }
}]
