//
// Baseline deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'subscription'

// ----------
// PARAMETERS
// ----------


// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration.')
module baseline_rg'../resourceGroup.bicep' = {
  name: 'baseline_rg'
  params: {
    parLocation: 'westeurope'
    parResourceGroupName: 'baseline-rg'
    parTelemetryOptOut: true
    parTags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
}
