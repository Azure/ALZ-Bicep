//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------
var policyAssignmentConfig = loadJsonContent('../assignments/parameters/mc-policyAssignmentManagementGroup.dine.parameters.min.json')

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_policy '../assignments/policyAssignmentManagementGroup.bicep' = {
  name: 'minimum policy'
  params: {
    parPolicyAssignmentName: policyAssignmentConfig.parameters.parPolicyAssignmentName.value
    parPolicyAssignmentDisplayName: policyAssignmentConfig.parameters.parPolicyAssignmentDisplayName.value
    parPolicyAssignmentDescription: policyAssignmentConfig.parameters.parPolicyAssignmentDescription.value
    parPolicyAssignmentDefinitionId: policyAssignmentConfig.parameters.parPolicyAssignmentDefinitionId.value
    parPolicyAssignmentParameters: policyAssignmentConfig.parameters.parPolicyAssignmentParameters
    parPolicyAssignmentNonComplianceMessages: policyAssignmentConfig.parameters.parPolicyAssignmentNonComplianceMessages.value
    parPolicyAssignmentNotScopes: policyAssignmentConfig.parameters.parPolicyAssignmentNotScopes.value
    parTelemetryOptOut: policyAssignmentConfig.parameters.parTelemetryOptOut.value
    }
}
