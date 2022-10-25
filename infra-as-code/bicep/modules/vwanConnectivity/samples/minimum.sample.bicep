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
    parAzFirewallAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parVirtualNetworkIdToLink: '/subscriptions/xxxxxxxxx-b761-4132-9ed1-2c90d07c4885/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet'
  }
}
