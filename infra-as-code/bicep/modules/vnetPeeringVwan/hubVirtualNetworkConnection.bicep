@description('Virtual WAN Hub resource ID. No default')
param parVirtualHubResourceId string

@description('Remote Spoke virtual network resource ID. No default')
param parRemoteVirtualNetworkResourceId string

var varVwanHubName = split(parVirtualHubResourceId, '/')[8]

var varSpokeVnetName = split(parRemoteVirtualNetworkResourceId, '/')[8]

var varVnetPeeringVwanName = '${varVwanHubName}/${varSpokeVnetName}-vhc'

resource resVnetPeeringVwan 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-05-01' = if (!empty(parVirtualHubResourceId) && !empty(parRemoteVirtualNetworkResourceId)) {
  name: varVnetPeeringVwanName
  properties: {
    remoteVirtualNetwork: {
      id: parRemoteVirtualNetworkResourceId
    }
  }
}

output outHubVirtualNetworkConnectionName string = resVnetPeeringVwan.name
output outHubVirtualNetworkConnectionResourceId string = resVnetPeeringVwan.id
