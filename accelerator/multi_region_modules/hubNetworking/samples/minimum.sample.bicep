//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_hub_network '../hubNetworking_multiRegion.bicep' = {
  name: 'minimum_hub_network'
  params: {
    parLocation: location
    parSecondaryLocation: location
    parAzFirewallAvailabilityZones: []
    parAzErGatewayAvailabilityZones: []
    parAzVpnGatewayAvailabilityZones: []
  }
}
