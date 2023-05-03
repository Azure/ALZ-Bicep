//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

@sys.description('The Spoke Virtual Network Resource ID.')
param parSpokeVirtualNetworkResourceId string = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<RG-NAME>/providers/Microsoft.Network/virtualNetworks/<VNET-NAME>'

@sys.description('The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.')
param parPrivateDnsZoneResourceId string = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<RG-NAME>/providers/Microsoft.Network/privateDnsZones/<ZONE-NAME>'

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module baseline_private_dns_zone_linking '../privateDnsZoneLinks.bicep' = {
  name: 'baseline_vnet_peering'
  params: {
    parPrivateDnsZoneResourceId: parPrivateDnsZoneResourceId
    parSpokeVirtualNetworkResourceId: parSpokeVirtualNetworkResourceId
  }
}
