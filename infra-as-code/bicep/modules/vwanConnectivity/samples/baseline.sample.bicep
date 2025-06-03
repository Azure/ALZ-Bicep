//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
param parLocation string = 'westus'
var parCompanyPrefix = 'contoso'
// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_vwan_conn '../vwanConnectivity.bicep' = {
  name: 'minimum_vwan_conn'
  params: {
    parLocation: parLocation
    parVirtualHubEnabled: true
    parVirtualWanHubs: [
      {
        parVpnGatewayEnabled: true
        parExpressRouteGatewayEnabled: true
        parAzFirewallEnabled: true
        parVirtualHubAddressPrefix: '10.100.0.0/23'
        parHubLocation: 'centralus'
        parHubRoutingPreference: 'ExpressRoute' //allowed values are 'ASPath','VpnGateway','ExpressRoute'
        parVirtualRouterAutoScaleConfiguration: 2 //minimum capacity should be between 2 to 50
        parVirtualHubRoutingIntentDestinations: []
        parAzFirewallDnsProxyEnabled: true
        parAzFirewallDnsServers: []
        parAzFirewallIntelMode: 'Alert'
        parAzFirewallTier: 'Standard'
        parAzFirewallAvailabilityZones: [
          '1'
          '2'
          '3'
        ]
        parSidecarVirtualNetwork: {
          sidecarVirtualNetworkEnabled: false
          addressPrefixes: [
            '10.101.0.0/24'
          ]
        }
      }
    ]
    parVirtualWanName: '${parCompanyPrefix}-vwan-${parLocation}'
    parVirtualWanHubName: '${parCompanyPrefix}-vhub'
    parVpnGatewayName: '${parCompanyPrefix}-vpngw'
    parExpressRouteGatewayName: '${parCompanyPrefix}-ergw'
    parAzFirewallName: '${parCompanyPrefix}-fw'
    parAzFirewallPoliciesName: '${parCompanyPrefix}-azfwpolicy-${parLocation}'
    parVpnGatewayScaleUnit: 1
    parExpressRouteGatewayScaleUnit: 1
    parDdosEnabled: true
    parDdosPlanName: '${parCompanyPrefix}-ddos-plan'
    parPrivateDnsZonesEnabled: true
    parPrivateDnsZonesResourceGroup: resourceGroup().name
    parTags: {
      key1: 'value1'
    }
    parTelemetryOptOut: false
  }
}
