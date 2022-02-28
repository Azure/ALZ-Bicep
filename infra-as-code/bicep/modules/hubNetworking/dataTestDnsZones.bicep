// param parDnsZonesFromOutput object = {
//   azureAutomation: {
//     name: 'privatelink.azure-automation.net'
//     id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azure-automation.net'
//   }
//   azureDB: {
//     name: 'privatelink.database.windows.net'
//     id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.database.windows.net'
//   }
// }

param parDnsZonesFromOutput object = {
  azureAutomation: 'privatelink.azure-automation.net'
  azureDB: 'privatelink.database.windows.net'
}

// {
// name: 'privatelink.sql.azuresynapse.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.sql.azuresynapse.net'
// }
// {
// name: 'privatelink.azuresynapse.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azuresynapse.net'
// }
// {
// name: 'privatelink.blob.core.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.blob.core.windows.net'
// }
// {
// name: 'privatelink.table.core.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.table.core.windows.net'
// }
// {
// name: 'privatelink.queue.core.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.queue.core.windows.net'
// }
// {
// name: 'privatelink.file.core.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.file.core.windows.net'
// }
// {
// name: 'privatelink.web.core.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.web.core.windows.net'
// }
// {
// name: 'privatelink.dfs.core.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.dfs.core.windows.net'
// }
// {
// name: 'privatelink.documents.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.documents.azure.com'
// }
// {
// name: 'privatelink.mongo.cosmos.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.mongo.cosmos.azure.com'
// }
// {
// name: 'privatelink.cassandra.cosmos.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.cassandra.cosmos.azure.com'
// }
// {
// name: 'privatelink.gremlin.cosmos.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.gremlin.cosmos.azure.com'
// }
// {
// name: 'privatelink.table.cosmos.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.table.cosmos.azure.com'
// }
// {
// name: 'privatelink.northeurope.batch.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.northeurope.batch.azure.com'
// }
// {
// name: 'privatelink.postgres.database.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.postgres.database.azure.com'
// }
// {
// name: 'privatelink.mysql.database.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.mysql.database.azure.com'
// }
// {
// name: 'privatelink.mariadb.database.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.mariadb.database.azure.com'
// }
// {
// name: 'privatelink.vaultcore.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.vaultcore.azure.net'
// }
// {
// name: 'privatelink.northeurope.azmk8s.io'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.northeurope.azmk8s.io'
// }
// {
// name: 'northeurope.privatelink.siterecovery.windowsazure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/northeurope.privatelink.siterecovery.windowsazure.com'
// }
// {
// name: 'privatelink.servicebus.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.servicebus.windows.net'
// }
// {
// name: 'privatelink.azure-devices.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azure-devices.net'
// }
// {
// name: 'privatelink.eventgrid.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.eventgrid.azure.net'
// }
// {
// name: 'privatelink.azurewebsites.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azurewebsites.net'
// }
// {
// name: 'privatelink.api.azureml.ms'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.api.azureml.ms'
// }
// {
// name: 'privatelink.notebooks.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.notebooks.azure.net'
// }
// {
// name: 'privatelink.service.signalr.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.service.signalr.net'
// }
// {
// name: 'privatelink.afs.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.afs.azure.net'
// }
// {
// name: 'privatelink.datafactory.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.datafactory.azure.net'
// }
// {
// name: 'privatelink.adf.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.adf.azure.com'
// }
// {
// name: 'privatelink.redis.cache.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.redis.cache.windows.net'
// }
// {
// name: 'privatelink.redisenterprise.cache.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.redisenterprise.cache.azure.net'
// }
// {
// name: 'privatelink.purview.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.purview.azure.com'
// }
// {
// name: 'privatelink.digitaltwins.azure.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.digitaltwins.azure.net'
// }
// {
// name: 'privatelink.azconfig.io'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azconfig.io'
// }
// {
// name: 'privatelink.webpubsub.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.webpubsub.azure.com'
// }
// {
// name: 'privatelink.azure-devices-provisioning.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azure-devices-provisioning.net'
// }
// {
// name: 'privatelink.cognitiveservices.azure.com'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.cognitiveservices.azure.com'
// }
// {
// name: 'privatelink.azurecr.io'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.azurecr.io'
// }
// {
// name: 'privatelink.search.windows.net'
// id: '/subscriptions/91c40acc-a2b4-4ffd-8c3b-8ba5e4cc7daf/resourceGroups/rsg-dns-test/providers/Microsoft.network/privateDnsZones/privatelink.search.windows.net'
// }
// }

// output outDnsZones array = parDnsZonesFromOutput

output outDnsZones object = parDnsZonesFromOutput

output outDnsZonesItems array = items(parDnsZonesFromOutput)

var varDnsZonesItems = [for dnsZone in items(parDnsZonesFromOutput): {
  zoneName: dnsZone.value
}]

output testArray array = varDnsZonesItems

resource resPrivateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [for privateDnsZone in varDnsZonesItems:  {
  name: privateDnsZone.zoneName
  location: 'global'
}]
