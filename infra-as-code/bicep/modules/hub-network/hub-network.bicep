/*
SUMMARY: Module to deploy ALZ Hub Network 
DESCRIPTION: The following components will be options in this deployment
              VNET
              Subnets
              VPN Gateway
              ExpressRoute Gateway
              Azure Firewall or 3rd Party NVA
              NSG
              Ddos Plan
              Bastion
AUTHOR/S: Troy Ault
VERSION: 1.0.0
*/

//@description('The Azure regions into which the resources should be deployed.')
//param parLocations array = [
//  'eastus2'
//]

@description('Switch which allows Bastion deployment to be disabled')
param parBastionEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled')
param parDdosEnabled bool = true

@description('Switch which allows Azure Firewall deployment to be disabled')
param parAzureFirewallEnabled bool = true

@description('Switch which allows Virtual Network Gateway deployment to be disabled')
param parGatewayEnabled bool = true

@description('DDOS Plan Name')
param parDdosPlanName string = 'MyDDosPlan'

@description('Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard')
param parBastionSku string = 'Standard'

@description('Public Ip Address SKU')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIPSku string = 'Standard'

@description('Tags you would like to be applied to all resources in this module')
param parTags object = {}

@description('Parameter to specify Type of Gateway to deploy')
@allowed([
  'Vpn'
  'ExpressRoute'
  'LocalGateway'
])
param parGatewayType string = 'Vpn'

@description('Name of the Express Route/VPN Gateway which will be created')
param parGatewayName string = 'MyGateway'

@description('Type of virtual Network Gateway')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param parVpnType string ='RouteBased'

@description('Sku/Tier of Virtual Network Gateway to deploy')
param parVpnSku string = 'VpnGw1'

@description('The IP address range for all virtual networks to use.')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@description('Prefix Used for Hub Network')
param parHubNetworkPrefix string = 'Hub'

@description('Azure Firewall Name')
param parAzureFirewallName string ='MyAzureFirewall'

@description('Name of Route table to create for the default route of Hub')
param parHubRouteTableName string = 'HubRouteTable'

@description('The name and IP address range for each subnet in the virtual networks.')
param parSubnets array = [
  {
    name: 'frontend'
    ipAddressRange: '10.10.5.0/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.10.10.0/24'
  }
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.10.15.0/24' 
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.10.252.0/24'
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.10.254.0/24'
  }
]

@description('Array of DNS Zones to provision in Hub Virtual Network.')
param parPrivateDnsZones array =[
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
  'privatelink.${resourceGroup().location}.batch.azure.com'
  'privatelink.postgres.database.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.mariadb.database.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.${resourceGroup().location}.azmk8s.io'
  '${resourceGroup().location}.privatelink.siterecovery.windowsazure.com'
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
  'privatelink.digitaltwins.azure.net'
]


var varSubnetProperties = [for subnet in parSubnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

var varBastionName = 'bastion-${resourceGroup().location}'

resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-02-01' = if(parDdosEnabled) {
  name: parDdosPlanName
  location: resourceGroup().location
  tags: parTags 
}


resource resHubVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${parHubNetworkPrefix}-${resourceGroup().location}'
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes:[
        parHubNetworkAddressPrefix
      ]
    }
    subnets: varSubnetProperties
    enableDdosProtection:parDdosEnabled
    ddosProtectionPlan: (parDdosEnabled) ? {
      id: resDdosProtectionPlan.id
      } : null
  }
}


resource resBastionPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = if(parBastionEnabled){
  location: resourceGroup().location
  name: '${varBastionName}-PublicIp'
  tags: parTags
  sku: {
      name: parPublicIPSku
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}


resource resBastionSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: resHubVirtualNetwork
  name: 'AzureBastionSubnet'
} 


resource resBastion 'Microsoft.Network/bastionHosts@2021-02-01' = if(parBastionEnabled){
  location: resourceGroup().location
  name: varBastionName
  tags: parTags
  sku:{
    name: parBastionSku
  }
  properties: {
      dnsName: uniqueString(resourceGroup().id)
      ipConfigurations: [
          {
              name: 'IpConf'
              properties: {
                  subnet: {
                    id: resBastionSubnetRef.id
                  }
                  publicIPAddress: {
                      id: resBastionPublicIP.id
                  }
              }
          }
      ]
  }
}


resource resGatewaySubnetRef 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: resHubVirtualNetwork
  name: 'GatewaySubnet'
} 


resource resGatewayPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = if(parGatewayEnabled){
  location: resourceGroup().location
  name: '${parGatewayName}-PublicIp'
  tags: parTags
  sku: {
      name: parPublicIPSku
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}


resource resVPNGateway 'Microsoft.Network/virtualNetworkGateways@2021-02-01' = if(parGatewayEnabled){
  name: parGatewayName
  location: resourceGroup().location
  tags: parTags
  properties:{
    activeActive: false
    enableBgp: false
    gatewayType: parGatewayType
    vpnType: parVpnType
    sku:{
      name: parVpnSku
      tier: parVpnSku
    }
    ipConfigurations:[
      {
        id: resHubVirtualNetwork.id
        name: 'vnetGatewayConfig'
        properties:{
          publicIPAddress:{
            id: resGatewayPublicIP.id
          }
          subnet:{
            id: resGatewaySubnetRef.id
          }
        }
      }
    ]
  }
}


resource resAzureFirewallSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: resHubVirtualNetwork
  name: 'AzureFirewallSubnet'
} 


resource resAzureFirewallPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = if(parAzureFirewallEnabled){
  location: resourceGroup().location
  name: '${parAzureFirewallName}-PublicIp'
  tags: parTags
  sku: {
      name: parPublicIPSku
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}


resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2021-02-01' = if(parAzureFirewallEnabled){
  name: parAzureFirewallName
  location: resourceGroup().location
  tags: parTags
  properties:{
    networkRuleCollections: [
      {
        name: 'VmInternetAccess'
        properties: {
          priority: 101
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'AllowVMAppAccess'
              description: 'Allows VM access to the web'
              protocols: [
                'TCP'
              ]
              sourceAddresses: [
                parHubNetworkAddressPrefix
              ]
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '80'
                '443'
              ]
            }
          ]
        }
      }
    ]
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: resAzureFirewallPublicIP.id
          }
        }
      }
    ]
    threatIntelMode: 'Alert'
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    additionalProperties: {
       'Network.DNS.EnableProxy': 'true'
    }
  }
}

resource resHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = {
  name: parHubRouteTableName
  location: resourceGroup().location
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}


resource resPrivateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [for privateDnsZone in parPrivateDnsZones: {
  name: privateDnsZone
  location: 'global'
  tags: parTags
}]


output outAzureFirewallPrivateIP string = resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
output outAzureFirewallName string = parAzureFirewallName
output outPrivateDnsZones array = [for i in range(0,length(parPrivateDnsZones)):{
  name: resPrivateDnsZones[i].name
  id: resPrivateDnsZones[i].id
}]
