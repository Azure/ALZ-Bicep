/*
SUMMARY: Module to deploy the Private DNS Zones as per the Azure Landing Zone conceptual architecture 
DESCRIPTION: The following components will deployed
              Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
AUTHOR/S: aultt, jtracey93, cloudchristoph
VERSION: 1.x.x
*/
@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param parRegion string = resourceGroup().location

@description('Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones')
param parPrivateDnsZones array = [
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

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Resource ID of Hub VNet for Private DNS Zone VNet Links')
param parHubVirtualNetworkId string


resource resPrivateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [for privateDnsZone in parPrivateDnsZones: {
  name: privateDnsZone
  location: 'global'
  tags: parTags
}]

resource resVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for privateDnsZoneName in parPrivateDnsZones: {
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

output outPrivateDnsZones array = [for i in range(0, length(parPrivateDnsZones)): {
  name: resPrivateDnsZones[i].name
  id: resPrivateDnsZones[i].id
}]
