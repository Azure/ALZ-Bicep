//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline_policy '../definitions/customPolicyDefinitions.bicep' = {
  name: 'minimum policy'
  params: {
    parTargetManagementGroupId: 'alz'
    parTelemetryOptOut: false
  }
}
