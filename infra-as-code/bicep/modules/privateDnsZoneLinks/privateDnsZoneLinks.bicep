targetScope = 'resourceGroup'

@sys.description('The Spoke Virtual Network Resource ID.')
param parSpokeVirtualNetworkResourceId string = ''

@sys.description('The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.')
param parPrivateDnsZoneResourceIds array = []

var varSpokeVirtualNetworkName = split(parSpokeVirtualNetworkResourceId, '/')[8]

resource resPrivateDnsZoneLinkToSpoke 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for zones in parPrivateDnsZoneResourceIds: if (!empty(parPrivateDnsZoneResourceIds)) {
  location: 'global'
  name: '${split(zones, '/')[8]}/dnslink-to-${varSpokeVirtualNetworkName}'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: parSpokeVirtualNetworkResourceId
    }
  }
}]
