//
// Baseline deployment sample
//

// Use this sample to deploy a Well-Architected aligned resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

// ---------
// VARIABLES
// ---------

// Company prefix for unit testing
var parCompanyPrefix = 'test'

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline_hub_network '../hubNetworking.bicep' = {
  name: 'baseline_hub_network'
  params: {
    parLocation: location
    parPublicIpSku: 'Standard'
    parAzFirewallAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parAzErGatewayAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parAzVpnGatewayAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
  }
}

@description('Baseline resource configuration using ExpressRoute')
module baseline_hub_network_with_ER '../hubNetworking.bicep' = {
  name: 'baseline_hub_network_with_ER'
  params: {
    parLocation: location
    parPublicIpSku: 'Standard'
    parAzFirewallAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parAzErGatewayAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parAzVpnGatewayAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parExpressRouteGatewayConfig: {
      name: '${parCompanyPrefix}-ExpressRoute-Gateway'
      gatewayType: 'ExpressRoute'
      sku: 'ErGw1AZ'
      vpnType: 'RouteBased'
      vpnGatewayGeneration: 'None'
      enableBgp: false
      activeActive: false
      enableBgpRouteTranslationForNat: false
      enableDnsForwarding: false
      bgpPeeringAddress: ''
      bgpSettings: {
        asn: 65515
        bgpPeeringAddress: ''
        peerWeight: 5
      }
      ipConfigurationName: 'vnetGatewayConfig'
      ipConfigurationActiveActiveName: 'vnetGatewayConfig2'
    }
  }
}

@description('Baseline resource configuration using a VPN Gateway')
module baseline_hub_network_with_VPN '../hubNetworking.bicep' = {
  name: 'baseline_hub_network_with_VPN'
  params: {
    parLocation: location
    parPublicIpSku: 'Standard'
    parAzFirewallAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parAzErGatewayAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parAzVpnGatewayAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parVpnGatewayConfig: {
      name: '${parCompanyPrefix}-Vpn-Gateway'
      gatewayType: 'Vpn'
      sku: 'VpnGw1AZAZ'
      vpnType: 'RouteBased'
      vpnGatewayGeneration: 'Generation1'
      enableBgp: false
      activeActive: false
      enableBgpRouteTranslationForNat: false
      enableDnsForwarding: false
      bgpPeeringAddress: ''
      bgpSettings: {
        asn: 65515
        bgpPeeringAddress: ''
        peerWeight: 5
      }
      vpnClientConfiguration: {}
      ipConfigurationName: 'vnetGatewayConfig'
      ipConfigurationActiveActiveName: 'vnetGatewayConfig2'
    }
  }
}
