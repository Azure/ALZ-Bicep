/*
SUMMARY: Module to connect your spoke virtual network to your Virtual WAN virtual hub/ 
DESCRIPTION: The following components will be options in this deployment
              Virtual Hub network connection
AUTHOR/S: faister, jtracey93
VERSION: 1.0.2
*/

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
