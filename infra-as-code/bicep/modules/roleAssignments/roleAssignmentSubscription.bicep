targetScope = 'subscription'

metadata name = 'ALZ Bicep - Role Assignment to a Subscription'
metadata description = 'Module to assign a role to a Subscription'

@sys.description('GUID for the role assignment name.')
param parRoleAssignmentNameGuid string = guid(subscription().subscriptionId, parRoleDefinitionId, parAssigneeObjectId)

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
