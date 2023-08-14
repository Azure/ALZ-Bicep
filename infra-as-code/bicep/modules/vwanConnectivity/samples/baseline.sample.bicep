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
    parAzFirewallTier: 'Standard'
    parVirtualHubEnabled: true
    parVirtualWanHubs:[{
      parVpnGatewayEnabled: true
      parExpressRouteGatewayEnabled: true
      parAzFirewallEnabled: true
      parVirtualHubAddressPrefix: '10.100.0.0/23'
      parHubLocation: 'centralus'
      parhubRoutingPreference: 'ExpressRoute' //allowed values are 'ASN','VpnGateway','ExpressRoute'
      parvirtualRouterAutoScaleConfiguration: 2 //minimum capacity should be between 2 to 50
      parVirtualHubRoutingIntentDestinations: []
    }]
    parAzFirewallDnsProxyEnabled: true
    parVirtualWanName: '${parCompanyPrefix}-vwan-${parLocation}'
    parVirtualWanHubName: '${parCompanyPrefix}-vhub'
    parVpnGatewayName: '${parCompanyPrefix}-vpngw'
    parExpressRouteGatewayName: '${parCompanyPrefix}-ergw'
    parAzFirewallName: '${parCompanyPrefix}-fw'
    parAzFirewallAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
    parVirtualNetworkIdToLink: '/subscriptions/xxxxxxxxx-b761-4132-9ed1-2c90d07c4885/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet'

    parAzFirewallPoliciesName: '${parCompanyPrefix}-azfwpolicy-${parLocation}'

    parVpnGatewayScaleUnit: 1

    parExpressRouteGatewayScaleUnit: 1

    parDdosEnabled: true
    parDdosPlanName: '${parCompanyPrefix}-ddos-plan'
    parPrivateDnsZonesEnabled: true

    parPrivateDnsZonesResourceGroup: resourceGroup().name
    parPrivateDnsZones: [
      'privatelink.${toLower(parLocation)}.azmk8s.io'
      'privatelink.${toLower(parLocation)}.batch.azure.com'
      'privatelink.${toLower(parLocation)}.kusto.windows.net'
      'privatelink.adf.azure.com'
      'privatelink.afs.azure.net'
      'privatelink.agentsvc.azure-automation.net'
      'privatelink.analysis.windows.net'
      'privatelink.api.azureml.ms'
      'privatelink.azconfig.io'
      'privatelink.azure-api.net'
      'privatelink.azure-automation.net'
      'privatelink.azurecr.io'
      'privatelink.azure-devices.net'
      'privatelink.azure-devices-provisioning.net'
      'privatelink.azurehdinsight.net'
      'privatelink.azurehealthcareapis.com'
      'privatelink.azurestaticapps.net'
      'privatelink.azuresynapse.net'
      'privatelink.azurewebsites.net'
      'privatelink.batch.azure.com'
      'privatelink.blob.core.windows.net'
      'privatelink.cassandra.cosmos.azure.com'
      'privatelink.cognitiveservices.azure.com'
      'privatelink.database.windows.net'
      'privatelink.datafactory.azure.net'
      'privatelink.dev.azuresynapse.net'
      'privatelink.dfs.core.windows.net'
      'privatelink.dicom.azurehealthcareapis.com'
      'privatelink.digitaltwins.azure.net'
      'privatelink.directline.botframework.com'
      'privatelink.documents.azure.com'
      'privatelink.eventgrid.azure.net'
      'privatelink.file.core.windows.net'
      'privatelink.gremlin.cosmos.azure.com'
      'privatelink.guestconfiguration.azure.com'
      'privatelink.his.arc.azure.com'
      'privatelink.kubernetesconfiguration.azure.com'
      'privatelink.managedhsm.azure.net'
      'privatelink.mariadb.database.azure.com'
      'privatelink.media.azure.net'
      'privatelink.mongo.cosmos.azure.com'
      'privatelink.monitor.azure.com'
      'privatelink.mysql.database.azure.com'
      'privatelink.notebooks.azure.net'
      'privatelink.ods.opinsights.azure.com'
      'privatelink.oms.opinsights.azure.com'
      'privatelink.pbidedicated.windows.net'
      'privatelink.postgres.database.azure.com'
      'privatelink.prod.migration.windowsazure.com'
      'privatelink.purview.azure.com'
      'privatelink.purviewstudio.azure.com'
      'privatelink.queue.core.windows.net'
      'privatelink.redis.cache.windows.net'
      'privatelink.redisenterprise.cache.azure.net'
      'privatelink.search.windows.net'
      'privatelink.service.signalr.net'
      'privatelink.servicebus.windows.net'
      'privatelink.siterecovery.windowsazure.com'
      'privatelink.sql.azuresynapse.net'
      'privatelink.table.core.windows.net'
      'privatelink.table.cosmos.azure.com'
      'privatelink.tip1.powerquery.microsoft.com'
      'privatelink.token.botframework.com'
      'privatelink.vaultcore.azure.net'
      'privatelink.web.core.windows.net'
      'privatelink.webpubsub.azure.com'
    ]

    parTags: {
      key1: 'value1'
    }
    parTelemetryOptOut: false
  }
}
