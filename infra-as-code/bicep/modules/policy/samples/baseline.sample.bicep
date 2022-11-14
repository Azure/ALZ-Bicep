//
// Baseline deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------
var policyAssignmentConfig = loadJsonContent('../assignments/parameters/mc-policyAssignmentManagementGroup.dine.parameters.all.json')

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module minimum_policy '../assignments/policyAssignmentManagementGroup.bicep' = {
  name: 'baseline policy'
  params: {
    parPolicyAssignmentName: policyAssignmentConfig.parameters.parPolicyAssignmentName.value
    parPolicyAssignmentDisplayName: policyAssignmentConfig.parameters.parPolicyAssignmentDisplayName.value
    parPolicyAssignmentDescription: policyAssignmentConfig.parameters.parPolicyAssignmentDescription.value
    parPolicyAssignmentDefinitionId: policyAssignmentConfig.parameters.parPolicyAssignmentDefinitionId.value
    parPolicyAssignmentParameters: policyAssignmentConfig.parameters.parPolicyAssignmentParameters
    parPolicyAssignmentNonComplianceMessages: policyAssignmentConfig.parameters.parPolicyAssignmentNonComplianceMessages.value
    parPolicyAssignmentNotScopes: policyAssignmentConfig.parameters.parPolicyAssignmentNotScopes.value
    parTelemetryOptOut: policyAssignmentConfig.parameters.parTelemetryOptOut.value
    parPolicyAssignmentParameterOverrides: policyAssignmentConfig.parameters.parPolicyAssignmentParameterOverrides.value
    parPolicyAssignmentEnforcementMode: policyAssignmentConfig.parameters.parPolicyAssignmentEnforcementMode.value
    parPolicyAssignmentIdentityType: policyAssignmentConfig.parameters.parPolicyAssignmentIdentityType.value
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: policyAssignmentConfig.parameters.parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs.value
    parPolicyAssignmentIdentityRoleAssignmentsSubs: policyAssignmentConfig.parameters.parPolicyAssignmentIdentityRoleAssignmentsSubs.value
    parPolicyAssignmentIdentityRoleDefinitionIds: policyAssignmentConfig.parameters.parPolicyAssignmentIdentityRoleDefinitionIds.value
    }
}
