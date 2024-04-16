// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
  SUMMARY : Creates a Policy Exemption for a Policy Assignment in a Management Group
  AUTHOR/S: Cloud for Sovereignty
*/
targetScope = 'managementGroup'

@description('Policy Assignment Name')
param parPolicyAssignmentName string

@description('Policy Assignment Scope Name')
param parPolicyAssignmentScopeName string

@description('SLZ Policy Set Assignment id')
param parPolicyAssignmentId string = '/providers/microsoft.management/managementgroups/${parPolicyAssignmentScopeName}/providers/microsoft.authorization/policyassignments/${parPolicyAssignmentName}'

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
