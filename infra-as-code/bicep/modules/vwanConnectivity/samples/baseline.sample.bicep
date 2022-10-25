//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
param location string = 'westus'
var parCompanyPrefix = 'contoso'
// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_vwan_conn '../vwanConnectivity.bicep' = {
  name: 'minimum_vwan_conn'
  params: {
    parLocation: location
    parVirtualHubAddressPrefix: '10.100.0.0/23'
    parAzFirewallTier: 'Standard'
    parVirtualHubEnabled: true
    parVpnGatewayEnabled: true
    parExpressRouteGatewayEnabled: true
    parAzFirewallEnabled: true
    parAzFirewallDnsProxyEnabled: true
    parVirtualWanName: '${parCompanyPrefix}-vwan-${location}'
    parVirtualWanHubName: '${parCompanyPrefix}-vhub-${location}'
    parVpnGatewayName: '${parCompanyPrefix}-vpngw-${location}'
    parExpressRouteGatewayName: '${parCompanyPrefix}-ergw-${location}'
    parAzFirewallName: '${parCompanyPrefix}-fw-${location}'
    parAzFirewallAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parVirtualNetworkIdToLink: '/subscriptions/2cf8f06f-b761-4132-9ed1-2c90d07c4885/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet'

    parAzFirewallPoliciesName: '${parCompanyPrefix}-azfwpolicy-${location}'

    parVpnGatewayScaleUnit: 1

    parExpressRouteGatewayScaleUnit: 1

    parDdosEnabled: true
    parDdosPlanName: '${parCompanyPrefix}-ddos-plan'
    parPrivateDnsZonesEnabled: true

    parPrivateDnsZonesResourceGroup: resourceGroup().name
    parPrivateDnsZones: [
      'privatelink.azure-automation.net'
      'privatelink.database.windows.net'
      'privatelink.sql.azuresynapse.net'
      'privatelink.dev.azuresynapse.net'
      'privatelink.azuresynapse.net'
      'privatelink.blob.core.windows.net'
      'privatelink.table.core.windows.net'
      'privatelink.queue.core.windows.net'
      'privatelink.file.core.windows.net'
      'privatelink.web.core.windows.net'
      'privatelink.dfs.core.windows.net'
      'privatelink.documents.azure.com'
      'privatelink.mongo.cosmos.azure.com'
      'privatelink.cassandra.cosmos.azure.com'
      'privatelink.gremlin.cosmos.azure.com'
      'privatelink.table.cosmos.azure.com'
      'privatelink.${location}.batch.azure.com'
      'privatelink.postgres.database.azure.com'
      'privatelink.mysql.database.azure.com'
      'privatelink.mariadb.database.azure.com'
      'privatelink.vaultcore.azure.net'
      'privatelink.managedhsm.azure.net'
      'privatelink.${location}.azmk8s.io'
      'privatelink.${location}.backup.windowsazure.com'
      'privatelink.siterecovery.windowsazure.com'
      'privatelink.servicebus.windows.net'
      'privatelink.azure-devices.net'
      'privatelink.eventgrid.azure.net'
      'privatelink.azurewebsites.net'
      'privatelink.api.azureml.ms'
      'privatelink.notebooks.azure.net'
      'privatelink.service.signalr.net'
      'privatelink.monitor.azure.com'
      'privatelink.oms.opinsights.azure.com'
      'privatelink.ods.opinsights.azure.com'
      'privatelink.agentsvc.azure-automation.net'
      'privatelink.afs.azure.net'
      'privatelink.datafactory.azure.net'
      'privatelink.adf.azure.com'
      'privatelink.redis.cache.windows.net'
      'privatelink.redisenterprise.cache.azure.net'
      'privatelink.purview.azure.com'
      'privatelink.purviewstudio.azure.com'
      'privatelink.digitaltwins.azure.net'
      'privatelink.azconfig.io'
      'privatelink.cognitiveservices.azure.com'
      'privatelink.azurecr.io'
      'privatelink.search.windows.net'
      'privatelink.azurehdinsight.net'
      'privatelink.media.azure.net'
      'privatelink.his.arc.azure.com'
      'privatelink.guestconfiguration.azure.com'
    ]

    parTags: {
      key1: 'value1'
    }
    parTelemetryOptOut: false
  }
}
