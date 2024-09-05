targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Assignments'
metadata description = 'Module to assign policy definitions to management groups'

type nonComplianceMessageType = {
  @description('Message for non-compliance.')
  message: string

  @description('Policy definition reference ID.')
  policyDefinitionReferenceId: string
}[]

@minLength(1)
@maxLength(24)
@description('Policy assignment name.')
param parPolicyAssignmentName string

@description('Policy assignment display name.')
param parPolicyAssignmentDisplayName string

@description('Policy assignment description.')
param parPolicyAssignmentDescription string

@description('Policy definition ID.')
param parPolicyAssignmentDefinitionId string

@description('Parameter values for the assigned policy.')
param parPolicyAssignmentParameters object = {}

@description('Overrides for parameter values in parPolicyAssignmentParameters.')
param parPolicyAssignmentParameterOverrides object = {}

@description('Non-compliance messages for the assigned policy.')
param parPolicyAssignmentNonComplianceMessages nonComplianceMessageType = []

@description('Scope Resource IDs excluded from policy assignment.')
param parPolicyAssignmentNotScopes array = []

@allowed([
  'Default'
  'DoNotEnforce'
])
@description('Enforcement mode for the policy assignment.')
param parPolicyAssignmentEnforcementMode string = 'Default'

@description('List of required overrides for the policy assignment.')
param parPolicyAssignmentOverrides array = []

@description('List of required resource selectors for the policy assignment.')
param parPolicyAssignmentResourceSelectors array = []

@allowed([
  'None'
  'SystemAssigned'
])
@description('Identity type for the policy assignment (required for Modify/DeployIfNotExists effects).')
param parPolicyAssignmentIdentityType string = 'None'

@description('Additional Management Groups for System-assigned Managed Identity role assignments.')
param parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs array = []

@description('Subscription IDs for System-assigned Managed Identity role assignments.')
param parPolicyAssignmentIdentityRoleAssignmentsSubs array = []

@description('Subscription IDs and Resource Groups for System-assigned Managed Identity role assignments.')
param parPolicyAssignmentIdentityRoleAssignmentsResourceGroups array = []

@description('RBAC role definition IDs for Managed Identity role assignments (required for Modify/DeployIfNotExists effects).')
param parPolicyAssignmentIdentityRoleDefinitionIds array = []

@description('Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

var varPolicyAssignmentParametersMerged = union(parPolicyAssignmentParameters, parPolicyAssignmentParameterOverrides)

var varPolicyIdentity = parPolicyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'

var varPolicyAssignmentIdentityRoleAssignmentsMgsConverged = parPolicyAssignmentIdentityType == 'SystemAssigned' ? union(parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs, (array(managementGroup().name))) : []

// Customer Usage Attribution Id
var varCuaid = '78001e36-9738-429c-a343-45cc84e8a527'

resource resPolicyAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
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
