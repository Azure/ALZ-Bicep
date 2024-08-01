targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Resource Groups'
metadata description = 'Module used to assign a Role Assignment to multiple Resource Groups'

@sys.description('A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).')
param parResourceGroupIds array = []

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

@sys.description('The role assignment condition. Only built-in and custom RBAC roles with `Microsoft.Authorization/roleAssignments/write` and/or `Microsoft.Authorization/roleAssignments/delete` permissions can have a condition defined. Example: Owner, User Access Administrator and RBAC Administrator.')
param parRoleAssignmentCondition string = ''

@sys.description('Role assignment condition version. Currently the only accepted value is \'2.0\'')
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
