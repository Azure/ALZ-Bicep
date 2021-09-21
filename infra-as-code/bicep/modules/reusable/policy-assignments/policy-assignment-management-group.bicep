/*
SUMMARY: This module assigns Azure Policies to a specified Management Group as well as assigning the Managed Identity to various Management Groups 
DESCRIPTION: This module assigns Azure Policies to a specified Management Group.
AUTHOR/S: jtracey93
VERSION: 1.0.0
*/

targetScope = 'managementGroup'

@minLength(1)
@maxLength(24)
@description('The name of the policy assignment. e.g. "Deny-Public-IP"')
param parPolicyAssignmentName string

@description('The display name of the policy assignment. e.g. "Deny the creation of Public IPs"')
param parPolicyAssignmentDisplayName string

@description('The desription of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."')
param parPolicyAssignmentDescription string

@description('The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91." or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"')
param parPolicyAssignmentDefinitionID string

@description('An object containing the parameter values for the policy to be assigned. DEFAULT VALUE = {}')
param parPolicyAssignmentParameters object = {}

@description('An array containing object/s for the non-compliance messages for the policy to be assigned. See https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages for more details on use. DEFAULT VALUE = []')
param parPolicyAssignmentNonComplianceMessages array = []

@description('An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. [\'/providers/Microsoft.Management/managementgroups/alz\', \'/providers/Microsoft.Management/managementgroups/alz-sandbox\' ]. DEFAULT VALUE = []')
param parPolicyAssignmentNotScopes array = []

@allowed([
  'Default'
  'DoNotEnforce'
])
@description('The enforcement mode for the policy assignment. See https://aka.ms/EnforcementMode for more details on use. DEAFULT VALUE = "Default"')
param parPolicyAssignmentEnforcementMode string = 'Default'

@allowed([
  'None'
  'SystemAssigned'
])
@description('The type of identity to be created and assoiated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects . DEAFULT VALUE = "None"')
param parPolicyAssignmentIdentityType string = 'None'

@description('An array containing a list of Management Group IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to. e.g. [\'alz\', \'alz-sandbox\' ]. DEFAULT VALUE = [ <Management Group You Are Deploying To> ]')
param parPolicyAssignmentIdentityRoleAssignmentsMGs array = [
  '${managementGroup()}'
]

@description('An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to. e.g. [\'8200b669-cbc6-4e6c-b6d8-f4797f924074\', \'7d58dc5d-93dc-43cd-94fc-57da2e74af0d\' ]. DEFAULT VALUE = []')
param parPolicyAssignmentIdentityRoleAssignmentsSubs array = []

@description('An array containing a list of RBAC role definition IDs to be assigned to the identity to be created and assoiated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects . e.g. [\'/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c\']. DEFAULT VALUE = []')
param parPolicyAssignmentIdentityRoleDefinitionIDs array = []

var varPolicyIdentity = parPolicyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'

var varPolicyIdentityLocation = parPolicyAssignmentIdentityType == 'SystemAssigned' ? deployment().location : json('null')

resource resPolicyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: parPolicyAssignmentName
  properties: {
    displayName: parPolicyAssignmentDisplayName 
    description: parPolicyAssignmentDescription
    policyDefinitionId: parPolicyAssignmentDefinitionID
    parameters: parPolicyAssignmentParameters
    nonComplianceMessages: parPolicyAssignmentNonComplianceMessages
    notScopes: parPolicyAssignmentNotScopes
    enforcementMode: parPolicyAssignmentEnforcementMode
  }
  identity: {
    type: varPolicyIdentity
  }
  location: varPolicyIdentityLocation
}

// Handle Managed Identity RBAC Assignments to Management Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentMGsMany '../role-assignments/role-assignment-management-group-many.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIDs: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIDs) && !empty(parPolicyAssignmentIdentityRoleAssignmentsMGs)) {
  name: 'rbac-assign-mg-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parManagementGroupIds: parPolicyAssignmentIdentityRoleAssignmentsMGs
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
  }
}]

// Handle Managed Identity RBAC Assignments to Subscription scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentSubsMany '../role-assignments/role-assignment-subscription-many.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIDs: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIDs) && !empty(parPolicyAssignmentIdentityRoleAssignmentsSubs)) {
  name: 'rbac-assign-sub-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parSubscriptionIds: parPolicyAssignmentIdentityRoleAssignmentsSubs
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
  }
}]
