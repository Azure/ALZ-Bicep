targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Resource Groups'
metadata description = 'Module to assign a role to multiple Resource Groups'

@sys.description('List of Resource Groups for role assignment in the format subscriptionId/resourceGroupName (e.g., a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).')
param parResourceGroupIds array = []

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
module modRoleAssignment 'roleAssignmentResourceGroup.bicep' = [for resourceGroupId in parResourceGroupIds: {
  name: 'rbac-assign-${uniqueString(resourceGroupId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: resourceGroup(split(resourceGroupId, '/')[0], split(resourceGroupId, '/')[1])
  params: {
    parRoleAssignmentNameGuid: guid(resourceGroupId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
    parTelemetryOptOut: parTelemetryOptOut
    parRoleAssignmentCondition: !empty(parRoleAssignmentCondition) ? parRoleAssignmentCondition : null
    parRoleAssignmentConditionVersion: !empty(parRoleAssignmentCondition) ? parRoleAssignmentConditionVersion : null
  }
}]
