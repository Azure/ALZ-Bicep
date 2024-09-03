targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Management Groups'
metadata description = 'Module to assign a role to multiple Management Groups'

@sys.description('List of management group scopes for role assignment (e.g., [alz-platform-connectivity, alz-platform-identity]).')
param parManagementGroupIds array = []

@sys.description('Role Definition Id (e.g., Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@sys.description('Principal type: \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal/Managed Identity).')
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
