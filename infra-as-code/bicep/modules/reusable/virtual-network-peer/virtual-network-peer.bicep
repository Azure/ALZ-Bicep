/*
SUMMARY: Module create network peer from one virtual network to another
DESCRIPTION: The following components will be required parameters in this deployment
    parResourceGroupLocation
    parResourceGroupName
AUTHOR/S: aultt
VERSION: 1.0.0
*/

@description('Virtual Network ID of Virtual Network destination. No default')
param parDestinationVirtualNetworkID string

@description('Name of source virtual network we are peering.  No Default')
param parSourceVirtualNetworkName string

@description('Name of destination virtual network we are peering.  No Default')
param parDestinationVirtualNetworkName string

resource resVirtualNetworkPeer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name:  '${parSourceVirtualNetworkName}/${parDestinationVirtualNetworkName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    remoteVirtualNetwork: {
        id: parDestinationVirtualNetworkId
    }
  }
}
