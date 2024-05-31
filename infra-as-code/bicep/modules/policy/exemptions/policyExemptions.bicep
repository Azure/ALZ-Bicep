targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Exemptions'
metadata description = 'Module used to create a policy exemption for a policy assignment in a management group'

@sys.description('The ID of the policy set assignment for which the exemption will be established.')
param parPolicyAssignmentId string

@allowed([
  'Waiver'
  'Mitigated'
])
@sys.description('The exemption category to be used.')
param parExemptionCategory string = 'Waiver'

@sys.description('The description which provides context for the policy exemption.')
param parDescription string

@allowed([
  'Default'
  'DoNotValidate'
])
@sys.description('Sets the scope to permit an exemption to bypass this validation and be created beyond the assignment scope.')
param parAssignmentScopeValidation string = 'Default'

@sys.description('List used to specify which policy definition(s) in the initiative the subject resource has an exemption to.')
param parPolicyDefinitionReferenceIds array

@sys.description('The resource name of the policy exemption.')
param parExemptionName string

@sys.description('The display name of the exemption.')
param parExemptionDisplayName string

// Create Policy Exemption
resource resPolicyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: parExemptionName
  properties: {
    assignmentScopeValidation: parAssignmentScopeValidation
    description: parDescription
    displayName: parExemptionDisplayName
    exemptionCategory: parExemptionCategory
    policyAssignmentId: parPolicyAssignmentId
    policyDefinitionReferenceIds: parPolicyDefinitionReferenceIds
  }
}
