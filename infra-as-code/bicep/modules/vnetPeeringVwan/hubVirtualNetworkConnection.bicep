/*
SUMMARY: Module to connect your spoke virtual network to your Virtual WAN virtual hub/ 
DESCRIPTION: The following components will be options in this deployment
              Virtual Hub network connection
AUTHOR/S: faister
VERSION: 1.0.1
*/

@description('Virtual WAN Azure resource ID. Default: Empty String')
param parVirtualHubResourceId string = ''

@description('Prefix Used for Spoke virtual network. Default: Empty String')
param parRemoteVirtualNetworkResourceId string = ''

var varVwanHubName = split(parVirtualHubResourceId, '/')[8]

var varSpokeVnetName = split(parRemoteVirtualNetworkResourceId, '/')[8]

var varVnetPeeringVwanName = '${varVwanHubName}/${varSpokeVnetName}/'

resource resVnetPeeringVwan 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-05-01' = if (!empty(parVirtualHubResourceId) && !empty(parRemoteVirtualNetworkResourceId)) {
  name: varVnetPeeringVwanName
  properties: {
    remoteVirtualNetwork: {
      id: parRemoteVirtualNetworkResourceId
    }
  }
}

output outHubVirtualNetworkConnectionResourceId string = resVnetPeeringVwan.id
