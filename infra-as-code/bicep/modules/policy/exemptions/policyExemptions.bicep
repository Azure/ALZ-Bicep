targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Exemptions'
metadata description = 'Creates a policy exemption for a management group policy assignment.'

@sys.description('The policy assignment ID for the exemption.')
param parPolicyAssignmentId string

@allowed([
  'Waiver'
  'Mitigated'
])
@sys.description('Exemption category.')
param parExemptionCategory string = 'Waiver'

@sys.description('Context for the exemption.')
param parDescription string

@allowed([
  'Default'
  'DoNotValidate'
])
@sys.description('Scope validation setting.')
param parAssignmentScopeValidation string = 'Default'

@sys.description('List of policy definitions exempted in the initiative.')
param parPolicyDefinitionReferenceIds array

@sys.description('Policy exemption resource name.')
param parExemptionName string

@sys.description('Exemption display name.')
param parExemptionDisplayName string

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
