targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Management Groups'
metadata description = 'Module used to assign a Role Assignment to multiple Management Groups'

@sys.description('A list of management group scopes that will be used for role assignment (i.e. [alz-platform-connectivity, alz-platform-identity]).')
param parManagementGroupIds array = []

@sys.description('Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@sys.description('Principal type of the assignee.  Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@sys.description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param parAssigneeObjectId string

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

@sys.description('''The role assignment condition. Only built-in and custom RBAC roles with `Microsoft.Authorization/roleAssignments/write` and/or `Microsoft.Authorization/roleAssignments/delete` permissions support having a condition defined. Example of built-in roles that support conditions: (Owner, User Access Administrator, Role Based Access Control Administrator). To generate conditions code:
- Create a role assignemnt with a condition from the portal for the privileged role that will be assigned.
- Select the code view from the advanced editor and copy the condition's code.
- Remove all newlines from the code
- Escape any single quote using a backslash (only in Bicep, no need in JSON parameters file)
''')
param parRoleAssignmentCondition string = ''

@sys.description('Role assignment condition version. Currently the only accepted value is \'2.0\'')
param parRoleAssignmentConditionVersion string = '2.0'

module modRoleAssignment 'roleAssignmentManagementGroup.bicep' = [for parManagementGroupId in parManagementGroupIds: {
  name: 'rbac-assign-${uniqueString(parManagementGroupId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: managementGroup(parManagementGroupId)
  params: {
    parRoleAssignmentNameGuid: guid(parManagementGroupId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
    parTelemetryOptOut: parTelemetryOptOut
    parRoleAssignmentCondition: !empty(parRoleAssignmentCondition) ? parRoleAssignmentCondition : null
    parRoleAssignmentConditionVersion: !empty(parRoleAssignmentCondition) ? parRoleAssignmentConditionVersion : null
  }
}]
