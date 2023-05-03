targetScope = 'resourceGroup'

@sys.description('The Spoke Virtual Network Resource ID.')
param parSpokeVirtualNetworkResourceId string = ''

@sys.description('The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.')
param parPrivateDnsZoneResourceId string = ''

var varSpokeVirtualNetworkName = split(parSpokeVirtualNetworkResourceId, '/')[8]

resource resPrivateDnsZoneLinkToSpoke 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (!empty(parPrivateDnsZoneResourceId)) {
  location: 'global'
  name: '${split(parPrivateDnsZoneResourceId, '/')[8]}/dnslink-to-${varSpokeVirtualNetworkName}'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: parSpokeVirtualNetworkResourceId
    }
  }
}
