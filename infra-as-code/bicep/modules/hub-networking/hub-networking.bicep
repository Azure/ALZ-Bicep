/*
SUMMARY: Module to deploy the Hub Network and it's components as per the Azure Landing Zone conceptual architecture 
DESCRIPTION: The following components will be options in this deployment
              Virtual Network (Vnet)
              Subnets
              VPN Gateway/ExpressRoute Gateway
              Azure Firewall
              Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
              DDos Standard Plan
              Bastion
AUTHOR/S: aultt
VERSION: 1.0.0
*/


@description('Switch which allows Bastion deployment to be disabled. Default: true')
param parBastionEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled. Default: true')
param parDdosEnabled bool = true

@description('Switch which allows Azure Firewall deployment to be disabled. Default: true')
param parAzureFirewallEnabled bool = true

@description('Switch which allows Virtual Network Gateway deployment to be disabled. Default true')
param parGatewayEnabled bool = true

@description('Switch which allows Private DNS Zones to be disabled. Default: true')
param parPrivateDNSZonesEnabled bool = true

@description('Prefix value which will be prepended to all resource names. Default: alz')
param parCompanyPrefix string = 'alz'

@description('DDOS Plan Name. Default: {parCompanyPrefix}-DDos-Plan')
param parDdosPlanName string = '${parCompanyPrefix}-DDos-Plan'

@description('Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard. Default: Standard')
param parBastionSku string = 'Standard'

@description('Public Ip Address SKU. Default: Standard')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIPSku string = 'Standard'

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Parameter to specify Type of Gateway to deploy. Default: Vpn')
@allowed([
  'Vpn'
  'ExpressRoute'
  'LocalGateway'
])
param parGatewayType string = 'Vpn'

@description('Name of the Express Route/VPN Gateway which will be created. Default: {parCompanyPrefix}-Gateway')
param parGatewayName string = '${parCompanyPrefix}-Gateway'

@description('Type of virtual Network Gateway. Default: RouteBased')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param parVpnType string ='RouteBased'

@description('Sku/Tier of Virtual Network Gateway to deploy. Default: VpnGw1')
param parVpnSku string = 'VpnGw1'

@description('The IP address range for all virtual networks to use. Default: 10.10.0.0/16')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@description('Prefix Used for Hub Network. Default: {parCompanyPrefix}-hub-{resourceGroup().location}')
param parHubNetworkName string = '${parCompanyPrefix}-hub-${resourceGroup().location}'

@description('Vpn Gateway Generation to deploy.  Default: Generation2')
param parVpnGatewayGeneration string = 'Generation2'

@description('Azure Firewall Name. Default: {parCompanyPrefix}-azure-firewall ')
param parAzureFirewallName string ='${parCompanyPrefix}-azure-firewall'

@description('Name of Route table to create for the default route of Hub. Default: {parCompanyPrefix}-hub-routetable')
param parHubRouteTableName string = '${parCompanyPrefix}-hub-routetable'

@description('Array of BGP paramaters to be utilized if enabling BGP.')
param parBgpOptions object = {
  enableBgp: false
  activeActive: false
  bgpsettings: {
    asn: 65515
    bgpPeeringAddress: ''
    peerWeight: 5
  }
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  asn: 65515
  bgpPeeringAddress: ''
  disableBgpRoutePropagation: false
}

@description('The name and IP address range for each subnet in the virtual networks. Default: AzureBastionSubnet, GatewaySubnet, AzureFirewall Subnet')
param parSubnets array = [
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

@description('Name Associated with Bastion Service:  Default: {parCompanyPrefix}-bastion')
param parBastionName string = '${parCompanyPrefix}-bastion'

@description('Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Privatezones')
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


resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-02-01' = if(parDdosEnabled) {
  name: parDdosPlanName
  location: resourceGroup().location
  tags: parTags 
}


resource resHubVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: parHubNetworkName
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
  name: '${parBastionName}-PublicIp'
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
  name: parBastionName
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
    activeActive: parBgpOptions.activeActive
    enableBgp: parBgpOptions.enableBgp
    enableBgpRouteTranslationForNat: parBgpOptions.enableBgpRouteTranslationForNat
    enableDnsForwarding: parBgpOptions.enableDnsForwarding
    bgpSettings: (parBgpOptions.enableBgp) ? {bgpSettings: parBgpOptions.bgpSettings
    } : null
    gatewayType: parGatewayType 
    vpnGatewayGeneration: (parGatewayType == 'VPN') ? parVpnGatewayGeneration : 'None'
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


resource resHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if(parAzureFirewallEnabled) {
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
          nextHopIpAddress: parAzureFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: parBgpOptions.disableBgpRoutePropagation
  }
}


resource resPrivateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [for privateDnsZone in parPrivateDnsZones: if(parPrivateDNSZonesEnabled) {
  name: privateDnsZone
  location: 'global'
  tags: parTags
}]


output outAzureFirewallPrivateIP string = parAzureFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''

output outAzureFirewallName string = parAzureFirewallEnabled ? parAzureFirewallName : ''

output outPrivateDnsZones array = [for i in range(0,length(parPrivateDnsZones)): {
  name: resPrivateDnsZones[i].name
  id: resPrivateDnsZones[i].id
}]

output outDdosPlanResourceId string = resDdosProtectionPlan.id
