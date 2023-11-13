metadata name = 'ALZ Bicep - Azure vWAN Hub Virtual Network Peerings'
metadata description = 'Module used to set up peering to Virtual Networks from vWAN Hub'

@sys.description('Virtual WAN Hub resource ID.')
param parVirtualWanHubResourceId string

@sys.description('Remote Spoke virtual network resource ID.')
param parRemoteVirtualNetworkResourceId string

@sys.description('Optional Virtual Hub Connection Name Prefix.')
param parVirtualHubConnectionPrefix string = ''

@sys.description('Optional Virtual Hub Connection Name Suffix. Example: -vhc')
param parVirtualHubConnectionSuffix string = '-vhc'

@sys.description('Enable Internet Security for the Virtual Hub Connection.')
param parEnableInternetSecurity bool = false

var varVwanHubName = split(parVirtualWanHubResourceId, '/')[8]

var varSpokeVnetName = split(parRemoteVirtualNetworkResourceId, '/')[8]

var varVnetPeeringVwanName = '${varVwanHubName}/${parVirtualHubConnectionPrefix}${varSpokeVnetName}${parVirtualHubConnectionSuffix}'

resource resVnetPeeringVwan 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2023-02-01' = if (!empty(parVirtualWanHubResourceId) && !empty(parRemoteVirtualNetworkResourceId)) {
  name: varVnetPeeringVwanName
  properties: {
    remoteVirtualNetwork: {
      id: parRemoteVirtualNetworkResourceId
    }
    enableInternetSecurity: parEnableInternetSecurity
  }
}

output outHubVirtualNetworkConnectionName string = resVnetPeeringVwan.name
output outHubVirtualNetworkConnectionResourceId string = resVnetPeeringVwan.id
