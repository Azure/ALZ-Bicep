/*
SUMMARY: Module to deploy the Private DNS Zones as per the Azure Landing Zone conceptual architecture 
DESCRIPTION: The following components will deployed
              Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
AUTHOR/S: aultt, jtracey93, cloudchristoph
VERSION: 1.x.x
*/
@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param parRegion string = resourceGroup().location

@description('Deploy all known Azure Private DNS Zones. Default: true')
param parDeployAllZones bool = true

@description('Array of custom DNS Zones to provision in Hub Virtual Network. Default: empty array, all known zones deployed')
param parPrivateDnsZones array = []

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Resource ID of Hub VNet for Private DNS Zone VNet Links')
param parHubVirtualNetworkId string

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varKnownDnsZones = [
  'privatelink.azure-automation.net'
  'privatelink.database.windows.net'
  'privatelink.sql.azuresynapse.net'
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
  'privatelink.${parRegion}.batch.azure.com'
  'privatelink.postgres.database.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.mariadb.database.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.${parRegion}.azmk8s.io'
  '${parRegion}.privatelink.siterecovery.windowsazure.com'
  'privatelink.servicebus.windows.net'
  'privatelink.azure-devices.net'
  'privatelink.eventgrid.azure.net'
  'privatelink.azurewebsites.net'
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.service.signalr.net'
  'privatelink.afs.azure.net'
  'privatelink.datafactory.azure.net'
  'privatelink.adf.azure.com'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  'privatelink.digitaltwins.azure.net'
  'privatelink.azconfig.io'
  'privatelink.webpubsub.azure.com'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.azurecr.io'
  'privatelink.search.windows.net'
  'privatelink.azurehdinsight.net'
  'privatelink.media.azure.net'
  'privatelink.his.arc.azure.com'
  'privatelink.guestconfiguration.azure.com'
]

var varPrivateDnsZones = parDeployAllZones ? varKnownDnsZones : parPrivateDnsZones

// Customer Usage Attribution Id
var varCuaid = '981733dd-3195-4fda-a4ee-605ab959edb6'

resource resPrivateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [for privateDnsZone in varPrivateDnsZones: {
  name: privateDnsZone
  location: 'global'
  tags: parTags
}]

resource resVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for privateDnsZoneName in varPrivateDnsZones: {
  name: '${privateDnsZoneName}/${privateDnsZoneName}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: parHubVirtualNetworkId
    }
  }
  dependsOn: resPrivateDnsZones
}]

module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

output outPrivateDnsZones array = [for i in range(0, length(varKnownDnsZones)): {
  name: resPrivateDnsZones[i].name
  id: resPrivateDnsZones[i].id
}]
