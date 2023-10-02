using '../hubNetworking.bicep'

param parHubNetworkAddressPrefix = '10.20.0.0/16'

param parSubnets = [
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.20.0.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.20.254.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.20.255.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallManagementSubnet'
    ipAddressRange: '10.20.253.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
]

param parDnsServerIps = []

param parPublicIpSku = 'Standard'

param parAzBastionEnabled = true

param parAzBastionSku = 'Standard'

param parDdosEnabled = true

param parAzFirewallEnabled = true

param parAzFirewallTier = 'Standard'

param parAzFirewallAvailabilityZones = []

param parAzErGatewayAvailabilityZones = []

param parAzVpnGatewayAvailabilityZones = []

param parAzFirewallDnsProxyEnabled = true

param parDisableBgpRoutePropagation = false

param parPrivateDnsZonesEnabled = true

param parVpnGatewayConfig = {
  name: 'alz-Vpn-Gateway'
  gatewayType: 'Vpn'
  sku: 'VpnGw1'
  vpnType: 'RouteBased'
  generation: 'Generation1'
  enableBgp: false
  activeActive: false
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  bgpPeeringAddress: ''
  bgpsettings: {
    asn: '65515'
    bgpPeeringAddress: ''
    peerWeight: '5'
  }
}

param parExpressRouteGatewayConfig = {
  name: 'alz-ExpressRoute-Gateway'
  gatewayType: 'ExpressRoute'
  sku: 'Standard'
  vpnType: 'RouteBased'
  generation: 'None'
  enableBgp: false
  activeActive: false
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  bgpPeeringAddress: ''
  bgpsettings: {
    asn: '65515'
    bgpPeeringAddress: ''
    peerWeight: '5'
  }
}

param parTelemetryOptOut = false