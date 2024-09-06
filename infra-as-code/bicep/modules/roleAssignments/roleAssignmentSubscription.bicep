targetScope = 'subscription'

metadata name = 'ALZ Bicep - Role Assignment to a Subscription'
metadata description = 'Module to assign a role to a Subscription'

@description('GUID for the role assignment name.')
param parRoleAssignmentNameGuid string = guid(subscription().subscriptionId, parRoleDefinitionId, parAssigneeObjectId)

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

// Customer Usage Attribution Id
var varCuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

resource resRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: parRoleAssignmentNameGuid
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', parRoleDefinitionId)
    principalId: parAssigneeObjectId
    principalType: parAssigneePrincipalType
    condition: !empty(parRoleAssignmentCondition) ? parRoleAssignmentCondition : null
    conditionVersion: !empty(parRoleAssignmentCondition) ? parRoleAssignmentConditionVersion : null
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(subscription().subscriptionId, parAssigneeObjectId)}'
  params: {}
}
