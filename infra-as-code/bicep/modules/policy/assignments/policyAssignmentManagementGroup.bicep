targetScope = 'managementGroup'

@minLength(1)
@maxLength(24)
@description('The name of the policy assignment. e.g. "Deny-Public-IP"')
param parPolicyAssignmentName string

@description('The display name of the policy assignment. e.g. "Deny the creation of Public IPs"')
param parPolicyAssignmentDisplayName string

@description('The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."')
param parPolicyAssignmentDescription string

@description('The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"')
param parPolicyAssignmentDefinitionId string

@description('An object containing the parameter values for the policy to be assigned. DEFAULT VALUE = {}')
param parPolicyAssignmentParameters object = {}

@description('An object containing parameter values that override those provided to parPolicyAssignmentParameters, usually via a JSON file and json(loadTextContent(FILE_PATH)). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between parPolicyAssignmentParameters & parPolicyAssignmentParameterOverrides, inputs provided to parPolicyAssignmentParameterOverrides will win. DEFAULT VALUE = {}')
param parPolicyAssignmentParameterOverrides object = {}

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
@description('The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. DEAFULT VALUE = "None"')
param parPolicyAssignmentIdentityType string = 'None'

@description('An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. [\'alz\', \'alz-sandbox\' ]. DEFAULT VALUE = [ <Management Group You Are Deploying To> ]')
param parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs array = []

@description('An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. [\'8200b669-cbc6-4e6c-b6d8-f4797f924074\', \'7d58dc5d-93dc-43cd-94fc-57da2e74af0d\' ]. DEFAULT VALUE = []')
param parPolicyAssignmentIdentityRoleAssignmentsSubs array = []

@description('An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. [\'/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c\']. DEFAULT VALUE = []')
param parPolicyAssignmentIdentityRoleDefinitionIds array = []

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varPolicyAssignmentParametersMerged = union(parPolicyAssignmentParameters, parPolicyAssignmentParameterOverrides)

var varPolicyIdentity = parPolicyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'

var varPolicyAssignmentIdentityRoleAssignmentsMgsConverged = parPolicyAssignmentIdentityType == 'SystemAssigned' ? union(parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs, (array(managementGroup().name))) : []

// Customer Usage Attribution Id
var varCuaid = '78001e36-9738-429c-a343-45cc84e8a527'

resource resPolicyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: parPolicyAssignmentName
  properties: {
    displayName: parPolicyAssignmentDisplayName 
    description: parPolicyAssignmentDescription
    policyDefinitionId: parPolicyAssignmentDefinitionId
    parameters: varPolicyAssignmentParametersMerged
    nonComplianceMessages: parPolicyAssignmentNonComplianceMessages
    notScopes: parPolicyAssignmentNotScopes
    enforcementMode: parPolicyAssignmentEnforcementMode
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
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location, parPolicyAssignmentName)}'
  params: {}
}
