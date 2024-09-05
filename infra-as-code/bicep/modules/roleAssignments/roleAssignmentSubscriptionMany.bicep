targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Subscriptions'
metadata description = 'Module to assign a role to multiple Subscriptions'

@description('List of subscription IDs (e.g., 4f9f8765-911a-4a6d-af60-4bc0473268c0).')
param parSubscriptionIds array = []

@description('Role Definition ID (e.g., Reader Role ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).')
param parRoleDefinitionId string

@description('Principal type: "Group" (Security Group) or "ServicePrincipal" (Service Principal/Managed Identity).')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@description('Object ID of the group, service principal, or managed identity.')
param parAssigneeObjectId string

@description('Opt out of deployment telemetry.')
param parTelemetryOptOut bool = false

@description('Role assignment condition (e.g., Owner, User Access Administrator).')
param parRoleAssignmentCondition string = ''

@description('Role assignment condition version. Must be "2.0".')
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
