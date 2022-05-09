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

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

module modRoleAssignment 'roleAssignmentManagementGroup.bicep' = [for parManagementGroupId in parManagementGroupIds: {
  name: 'rbac-assign-${uniqueString(parManagementGroupId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: managementGroup(parManagementGroupId)
  params: {
    parRoleAssignmentNameGuid: guid(parManagementGroupId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
    parTelemetryOptOut: parTelemetryOptOut
  }
}]
