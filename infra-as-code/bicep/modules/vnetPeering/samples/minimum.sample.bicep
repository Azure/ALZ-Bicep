//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_vnet_peering '../vnetPeering.bicep' = {
  name: 'minimum_vnet_peering'
  params: {
    parDestinationVirtualNetworkId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/<RG Name>/providers/Microsoft.Network/virtualNetworks/<Destination Vnet>'
    parDestinationVirtualNetworkName: '<Destination vnet>'
    parSourceVirtualNetworkName: '<Source vnet>'
  }
}
