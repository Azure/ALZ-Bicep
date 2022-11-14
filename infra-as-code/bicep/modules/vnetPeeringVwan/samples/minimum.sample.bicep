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

@description('Minimum resource configuration')
module minimum_vwa_vnet_peering '../vnetPeeringVwan.bicep' = {
  name: 'minimum_vwa_vnet_peering'
  params: {
    parVirtualWanHubResourceId: '/subscriptions/xxxxxxxxx-b761-4132-9ed1-2c90d07c4885/resourceGroups/rg-vwan/providers/Microsoft.Network/virtualWans/vwan-hub'
    parRemoteVirtualNetworkResourceId: '/subscriptions/xxxxxxxx-b761-4132-9ed1-2c90d07c4885/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet-remote'
  }
}
