targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Exemptions'
metadata description = 'Module used to create a policy exemption for a policy assignment in a management group'

@description('SLZ Policy Set Assignment id')
param parPolicyAssignmentId string

@allowed([
  'Waiver'
  'Mitigated'
])
@description('Exemption Category Default - Waiver')
param parExemptionCategory string = 'Waiver'

@description('Description')
param parDescription string

@allowed([
  'Default'
  'DoNotValidate'
])
@description('Assignment Scope')
param parAssignmentScopeValidation string = 'Default'

@description('Reference ids of Policies to be exempted')
param parPolicyDefinitionReferenceIds array

@description('Exemption Name')
param parExemptionName string

@description('Exemption Display Name')
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
