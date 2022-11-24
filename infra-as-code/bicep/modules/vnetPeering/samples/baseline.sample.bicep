//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module baseline_vnet_peering '../vnetPeering.bicep' = {
  name: 'baseline_vnet_peering'
  params: {
    parDestinationVirtualNetworkId: '/subscriptions/xxxxx-xxxx-xxxx-xx-xxxxxxxx/resourceGroups/<RG Name>/providers/Microsoft.Network/virtualNetworks/<Destination Vnet>'
    parDestinationVirtualNetworkName: '<Destination Vnet>'
    parSourceVirtualNetworkName: '<Source Vnet>'
    parAllowVirtualNetworkAccess: true
    parAllowForwardedTraffic: true
    parAllowGatewayTransit: false
    parUseRemoteGateways: false
    parTelemetryOptOut: false
  }
}
