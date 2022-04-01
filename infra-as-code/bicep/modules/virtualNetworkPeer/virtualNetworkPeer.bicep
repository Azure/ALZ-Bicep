/*
SUMMARY: Module create network peer from one virtual network to another
DESCRIPTION: The following components will be required parameters in this deployment
    parResourceGroupLocation
    parResourceGroupName
AUTHOR/S: aultt, KiZach
VERSION: 1.1.0

# Release notes 03/13/2022 - V1.1:
    - Added support for useRemoteGateways property.
    - Change is required to support a correct Hub/Spoke network peering with gateway support from spoke. 
      Without the change Spoke netwotk will not be able to be peered and user VPN/ER from the Hub network.
*/

@description('Virtual Network ID of Virtual Network destination. No default')
param parDestinationVirtualNetworkID string

@description('Name of source Virtual Network we are peering. No default')
param parSourceVirtualNetworkName string

@description('Name of destination virtual network we are peering.  No Default')
param parDestinationVirtualNetworkName string

@description('Switch to enable/disable Virtual Network Access for the Network Peer. Default = true')
param parAllowVirtualNetworkAccess bool = true

@description('Switch to enable/disable forwarded Traffic for the Network Peer. Default = true')
param parAllowForwardedTraffic bool = true

@description('Switch to enable/disable forwarded Traffic for the Network Peer. Default = false')
param parAllowGatewayTransit bool = false

@description('Switch to enable/disable remote Gateway for the Network Peer. Default = false')
param parUseRemoteGateways bool = false

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = 'ab8e3b12-b0fa-40aa-8630-e3f7699e2142'

resource resVirtualNetworkPeer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${parSourceVirtualNetworkName}/peer-to-${parDestinationVirtualNetworkName}'
  properties: {
    allowVirtualNetworkAccess: parAllowVirtualNetworkAccess
    allowForwardedTraffic: parAllowForwardedTraffic
    allowGatewayTransit: parAllowGatewayTransit
    useRemoteGateways: parUseRemoteGateways
    remoteVirtualNetwork: {
      id: parDestinationVirtualNetworkID
    }
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}
