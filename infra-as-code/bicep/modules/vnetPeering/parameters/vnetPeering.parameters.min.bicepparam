using '../vnetPeering.bicep'

param parDestinationVirtualNetworkId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/virtualNetworks/alz-hub-eastus'

param parSourceVirtualNetworkName = 'vnet-spoke'

param parDestinationVirtualNetworkName = 'alz-hub-eastus'

param parAllowVirtualNetworkAccess = true

param parAllowForwardedTraffic = true

param parAllowGatewayTransit = false

param parUseRemoteGateways = false

param parTelemetryOptOut = false
