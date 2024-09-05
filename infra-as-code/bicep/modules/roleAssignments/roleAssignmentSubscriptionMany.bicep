targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Subscriptions'
metadata description = 'Module to assign a role to multiple Subscriptions'

@sys.description('List of subscription IDs for role assignment (e.g., 4f9f8765-911a-4a6d-af60-4bc0473268c0).')
param parSubscriptionIds array = []

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

module modRoleAssignment 'roleAssignmentSubscription.bicep' = [for subscriptionId in parSubscriptionIds: {
  name: 'rbac-assign-${uniqueString(subscriptionId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: subscription(subscriptionId)
  params: {
    parRoleAssignmentNameGuid: guid(subscriptionId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
    parTelemetryOptOut: parTelemetryOptOut
    parRoleAssignmentCondition: !empty(parRoleAssignmentCondition) ? parRoleAssignmentCondition : null
    parRoleAssignmentConditionVersion: !empty(parRoleAssignmentCondition) ? parRoleAssignmentConditionVersion : null
  }
}]
