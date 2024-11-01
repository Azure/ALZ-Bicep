//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
param location string = 'westus'
// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_vwan_conn '../vwanConnectivity.bicep' = {
  name: 'minimum_vwan_conn'
  params: {
    parLocation: location
  }
}
