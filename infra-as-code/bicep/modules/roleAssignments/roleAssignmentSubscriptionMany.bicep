/*
SUMMARY: Role Assignments for 1 or more Subscriptions
DESCRIPTION:
  Module provides role assignment capabilities for Subscriptions.  The role assignments can be performed for:

  * Managed Identities (System and User Assigned)
  * Service Principals
  * Security Groups

AUTHOR/S: SenthuranSivananthan, jtracey93
VERSION: 1.1.0
*/
targetScope = 'managementGroup'

@description('A list of subscription IDs that will be used for role assignment (i.e. 4f9f8765-911a-4a6d-af60-4bc0473268c0)  Default = []')
param parSubscriptionIds array = []

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

// Customer Usage Attribution Id
var varCuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

module modRoleAssignment 'roleAssignmentSubscription.bicep' = [for subscriptionId in parSubscriptionIds: {
  name: 'rbac-assign-${uniqueString(subscriptionId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: subscription(subscriptionId)
  params: {
    parRoleAssignmentNameGuid: guid(subscriptionId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
