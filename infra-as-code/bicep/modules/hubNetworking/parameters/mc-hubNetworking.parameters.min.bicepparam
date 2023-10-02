using '../hubNetworking.bicep'

param parLocation = 'chinaeast2'

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

param parDdosEnabled = false

param parAzFirewallEnabled = true

param parAzFirewallTier = 'Standard'

param parAzFirewallAvailabilityZones = []

param parAzErGatewayAvailabilityZones = []

param parAzVpnGatewayAvailabilityZones = []

param parAzFirewallDnsProxyEnabled = true

param parDisableBgpRoutePropagation = false

param parPrivateDnsZonesEnabled = true

param parPrivateDnsZones = [
  'privatelink.azure-automation.cn'
  'privatelink.database.chinacloudapi.cn'
  'privatelink.blob.core.chinacloudapi.cn'
  'privatelink.table.core.chinacloudapi.cn'
  'privatelink.queue.core.chinacloudapi.cn'
  'privatelink.file.core.chinacloudapi.cn'
  'privatelink.web.core.chinacloudapi.cn'
  'privatelink.dfs.core.chinacloudapi.cn'
  'privatelink.documents.azure.cn'
  'privatelink.mongo.cosmos.azure.cn'
  'privatelink.cassandra.cosmos.azure.cn'
  'privatelink.gremlin.cosmos.azure.cn'
  'privatelink.table.cosmos.azure.cn'
  'privatelink.postgres.database.chinacloudapi.cn'
  'privatelink.mysql.database.chinacloudapi.cn'
  'privatelink.mariadb.database.chinacloudapi.cn'
  'privatelink.vaultcore.azure.cn'
  'privatelink.servicebus.chinacloudapi.cn'
  'privatelink.azure-devices.cn'
  'privatelink.eventgrid.azure.cn'
  'privatelink.chinacloudsites.cn'
  'privatelink.api.ml.azure.cn'
  'privatelink.notebooks.chinacloudapi.cn'
  'privatelink.signalr.azure.cn'
  'privatelink.azurehdinsight.cn'
  'privatelink.afs.azure.cn'
  'privatelink.datafactory.azure.cn'
  'privatelink.adf.azure.cn'
  'privatelink.redis.cache.chinacloudapi.cn'
]

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