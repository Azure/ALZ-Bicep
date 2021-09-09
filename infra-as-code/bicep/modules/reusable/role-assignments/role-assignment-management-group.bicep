/*
SUMMARY: Role Assignments for one Management Group
DESCRIPTION:
  Module provides role assignment capabilities for Management Groups.  The role assignments can be performed for:

  * Managed Identities (System and User Assigned)
  * Service Principals
  * Security Groups

AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/
targetScope = 'managementGroup'

@description('A GUID representing the role assignment name.  Default:  guid(parRoleDefinitionId, parAssigneeObjectId)')
param parRoleAssignmentNameGuid string = guid(parRoleDefinitionId, parAssigneeObjectId)

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
  name: parRoleAssignmentNameGuid
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', parRoleDefinitionId)
    principalId: parAssigneeObjectId
    principalType: parAssigneePrincipalType
  }
}
