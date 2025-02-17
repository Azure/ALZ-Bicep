targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Assignments'
metadata description = 'Assign policies to management groups'

type nonComplianceMessageType = {
  @description('Non-compliance message.')
  message: string

  @description('Policy definition reference ID.')
  policyDefinitionReferenceId: string
}[]

@minLength(1)
@maxLength(24)
@description('Policy assignment name.')
param parPolicyAssignmentName string

@description('Display name.')
param parPolicyAssignmentDisplayName string

@description('Assignment description.')
param parPolicyAssignmentDescription string

@description('Policy definition ID.')
param parPolicyAssignmentDefinitionId string

@description('Policy parameters.')
param parPolicyAssignmentParameters object = {}

@description('Parameter overrides.')
param parPolicyAssignmentParameterOverrides object = {}

@description('Non-compliance messages.')
param parPolicyAssignmentNonComplianceMessages nonComplianceMessageType = []

@description('Excluded scope IDs.')
param parPolicyAssignmentNotScopes array = []

@allowed([
  'Default'
  'DoNotEnforce'
])
@description('Enforcement mode.')
param parPolicyAssignmentEnforcementMode string = 'Default'

@description('Required overrides.')
param parPolicyAssignmentOverrides array = []

@description('Required resource selectors.')
param parPolicyAssignmentResourceSelectors array = []

@description('Policy definition version.')
param parPolicyAssignmentDefinitionVersion string?

@allowed([
  'None'
  'SystemAssigned'
])
@description('Identity type.')
param parPolicyAssignmentIdentityType string = 'None'

@description('Additional MGs for role assignments.')
param parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs array = []

@description('Subscription IDs for role assignments.')
param parPolicyAssignmentIdentityRoleAssignmentsSubs array = []

@description('Subscriptions & resource groups for role assignments.')
param parPolicyAssignmentIdentityRoleAssignmentsResourceGroups array = []

@description('RBAC role definition IDs.')
param parPolicyAssignmentIdentityRoleDefinitionIds array = []

@description('Opt-out of telemetry.')
param parTelemetryOptOut bool = false

var varPolicyAssignmentParametersMerged = union(parPolicyAssignmentParameters, parPolicyAssignmentParameterOverrides)

var varPolicyIdentity = parPolicyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'

var varPolicyAssignmentIdentityRoleAssignmentsMgsConverged = parPolicyAssignmentIdentityType == 'SystemAssigned' ? union(parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs, (array(managementGroup().name))) : []

// Customer Usage Attribution Id
var varCuaid = '78001e36-9738-429c-a343-45cc84e8a527'

resource resPolicyAssignment 'Microsoft.Authorization/policyAssignments@2025-01-01' = {
  name: parPolicyAssignmentName
  properties: {
    displayName: parPolicyAssignmentDisplayName
    description: parPolicyAssignmentDescription
    policyDefinitionId: parPolicyAssignmentDefinitionId
    parameters: varPolicyAssignmentParametersMerged
    nonComplianceMessages: parPolicyAssignmentNonComplianceMessages
    notScopes: parPolicyAssignmentNotScopes
    enforcementMode: parPolicyAssignmentEnforcementMode
    overrides: parPolicyAssignmentOverrides
    resourceSelectors: parPolicyAssignmentResourceSelectors
    definitionVersion: parPolicyAssignmentDefinitionVersion
  }
  identity: {
    type: varPolicyIdentity
  }
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  location: deployment().location
}

// Handle Managed Identity RBAC Assignments to Management Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentMgsMany '../../roleAssignments/roleAssignmentManagementGroupMany.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIds: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIds)) {
  name: 'rbac-assign-mg-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parManagementGroupIds: varPolicyAssignmentIdentityRoleAssignmentsMgsConverged
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Handle Managed Identity RBAC Assignments to Subscription scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentSubsMany '../../roleAssignments/roleAssignmentSubscriptionMany.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIds: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIds) && !empty(parPolicyAssignmentIdentityRoleAssignmentsSubs)) {
  name: 'rbac-assign-sub-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parSubscriptionIds: parPolicyAssignmentIdentityRoleAssignmentsSubs
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Handle Managed Identity RBAC Assignments to Resource Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentResourceGroupMany '../../roleAssignments/roleAssignmentResourceGroupMany.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIds: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIds) && !empty(parPolicyAssignmentIdentityRoleAssignmentsResourceGroups)) {
  name: 'rbac-assign-rg-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parResourceGroupIds: parPolicyAssignmentIdentityRoleAssignmentsResourceGroups
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location, parPolicyAssignmentName)}'
  params: {}
}

output outPolicyAssignmentId string = resPolicyAssignment.id
