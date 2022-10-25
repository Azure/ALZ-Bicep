//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param location string = resourceGroup().location
// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_private_dns '../privateDnsZones.bicep' = {
  name: 'minimum private DNS'
  params: {
    parLocation: location
  }
}
