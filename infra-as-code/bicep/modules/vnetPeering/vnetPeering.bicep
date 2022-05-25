@description('Virtual Network ID of Virtual Network destination. No default')
param parDestinationVirtualNetworkId string

@description('Name of source Virtual Network we are peering. No default')
param parSourceVirtualNetworkName string

@description('Name of destination virtual network we are peering. No default')
param parDestinationVirtualNetworkName string

@description('Switch to enable/disable Virtual Network Access for the Network Peer. Default = true')
param parAllowVirtualNetworkAccess bool = true

@description('Switch to enable/disable forwarded traffic for the Network Peer. Default = true')
param parAllowForwardedTraffic bool = true

@description('Switch to enable/disable gateway transit for the Network Peer. Default = false')
param parAllowGatewayTransit bool = false

@description('Switch to enable/disable remote gateway for the Network Peer. Default = false')
param parUseRemoteGateways bool = false

@description('Set Parameter to true to Opt-out of deployment telemetry. Default = false')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaId = 'ab8e3b12-b0fa-40aa-8630-e3f7699e2142'

resource resVirtualNetworkPeer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = {
  name: '${parSourceVirtualNetworkName}/peer-to-${parDestinationVirtualNetworkName}'
  properties: {
    allowVirtualNetworkAccess: parAllowVirtualNetworkAccess
    allowForwardedTraffic: parAllowForwardedTraffic
    allowGatewayTransit: parAllowGatewayTransit
    useRemoteGateways: parUseRemoteGateways
    remoteVirtualNetwork: {
      id: parDestinationVirtualNetworkId
    }
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaId}-${uniqueString(resourceGroup().location)}'
  params: {}
}
