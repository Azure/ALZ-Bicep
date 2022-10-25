//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'subscription'

// ----------
// PARAMETERS
// ----------


// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration.')
module minimum_rg'../resourceGroup.bicep' = {
  name: 'minimum_rg'
  params: {
    parLocation: 'westeurope'
    parResourceGroupName: 'minimum-rg'
    parTags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
}
