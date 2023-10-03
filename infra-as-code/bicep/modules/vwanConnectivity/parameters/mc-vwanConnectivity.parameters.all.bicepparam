using '../vwanConnectivity.bicep'

param parLocation = 'chinaeast2'

param parCompanyPrefix = 'alz'

param parAzFirewallTier = 'Standard'

param parVirtualHubEnabled = true

param parAzFirewallDnsProxyEnabled = true

param parAzFirewallDnsServers = []

param parVirtualWanName = 'alz-vwan-chinaeast2'

param parVirtualWanHubName = 'alz-vhub'

param parVpnGatewayName = 'alz-vpngw'

param parExpressRouteGatewayName = 'alz-ergw'

param parAzFirewallName = 'alz-fw'

param parAzFirewallAvailabilityZones = []

param parAzFirewallPoliciesName = 'alz-azfwpolicy-chinaeast2'

param parVirtualWanHubs = [
  {
    parVpnGatewayEnabled: true
    parExpressRouteGatewayEnabled: true
    parAzFirewallEnabled: true
    parVirtualHubAddressPrefix: '10.100.0.0/23'
    parHubLocation: 'chinaeast2'
    parHubRoutingPreference: 'ExpressRoute'
    parVirtualRouterAutoScaleConfiguration: 2
    parVirtualHubRoutingIntentDestinations: []
  }
]

param parVpnGatewayScaleUnit = 1

param parExpressRouteGatewayScaleUnit = 1

param parDdosEnabled = false

param parDdosPlanName = 'alz-ddos-plan'

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

param parPrivateDnsZoneAutoMergeAzureBackupZone = true

param parVirtualNetworkIdToLink = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/virtualNetworks/alz-hub-eastus'

param parTags = {
  Environment: 'Live'
}

param parTelemetryOptOut = false
