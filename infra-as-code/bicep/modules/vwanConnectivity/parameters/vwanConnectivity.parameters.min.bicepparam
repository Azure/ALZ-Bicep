using '../vwanConnectivity.bicep'

param parCompanyPrefix = 'alz'

param parAzFirewallTier = 'Standard'

param parVirtualHubEnabled = true

param parVirtualWanHubs = [
  {
    parVpnGatewayEnabled: true
    parExpressRouteGatewayEnabled: true
    parAzFirewallEnabled: true
    parVirtualHubAddressPrefix: '10.100.0.0/23'
    parHubLocation: 'eastus'
    parHubRoutingPreference: 'ExpressRoute'
    parVirtualRouterAutoScaleConfiguration: 2
    parVirtualHubRoutingIntentDestinations: []
  }
]

param parAzFirewallDnsProxyEnabled = true

param parAzFirewallAvailabilityZones = []

param parVpnGatewayScaleUnit = 1

param parExpressRouteGatewayScaleUnit = 1

param parDdosEnabled = true

param parPrivateDnsZonesEnabled = true

param parVirtualNetworkIdToLink = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/virtualNetworks/alz-hub-eastus'

param parTelemetryOptOut = false