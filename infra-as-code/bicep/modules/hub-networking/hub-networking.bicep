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

@description('Switch which allows BGP Propagation to be disabled on the routes: Default: false')
param  pardisableBgpRoutePropagation bool = false

@description('Switch which allows Private DNS Zones to be disabled. Default: true')
param parPrivateDNSZonesEnabled bool = true

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@description('Array of Gateways to be deployed. Array will consist of one or two items.  Specifically Vpn and/or ExpressRoute Default: Vpn')
param parGatewayArray array = [
  {
    name: '${parCompanyPrefix}-Vpn-Gateway'
    gatewaytype: 'Vpn'
    sku: 'VpnGw1'
    vpntype: 'RouteBased'
    generation: 'Generation2'
    enableBgp: false
    activeActive: false
    enableBgpRouteTranslationForNat: false
    enableDnsForwarding: false
    asn: 65515
    bgpPeeringAddress: ''
    bgpsettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
  }
  {
    name: '${parCompanyPrefix}-Gateway-ExpressRoute'
    gatewaytype: 'ExpressRoute'
    sku: 'ErGw1AZ'
    vpntype: 'RouteBased'
    generation: 'None'
    enableBgp: false
    activeActive: false
    enableBgpRouteTranslationForNat: false
    enableDnsForwarding: false
    asn: 65515
    bgpPeeringAddress: ''
    bgpsettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
  }

]

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

@description('The IP address range for all virtual networks to use. Default: 10.10.0.0/16')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@description('Prefix Used for Hub Network. Default: {parCompanyPrefix}-hub-{resourceGroup().location}')
param parHubNetworkName string = '${parCompanyPrefix}-hub-${resourceGroup().location}'

@description('Azure Firewall Name. Default: {parCompanyPrefix}-azure-firewall ')
param parAzureFirewallName string ='${parCompanyPrefix}-azure-firewall'

@description('Name of Route table to create for the default route of Hub. Default: {parCompanyPrefix}-hub-routetable')
param parHubRouteTableName string = '${parCompanyPrefix}-hub-routetable'

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

//Ddos Protection plan will only be enabled if parDdosEnabled is true.  
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

module modBastionPublicIp '../reusable/public-ip/public-ip.bicep' ={
  name: 'deploy-Bastion-Public-IP'
  params:{
    parPublicIpName: '${parBastionName}-PublicIp'
    parPublicIpSku: {
      name: parPublicIPSku
    }
    parPublicIpProperties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static' 
    }
    parTags: parTags
  }
}


resource resBastionSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: resHubVirtualNetwork
  name: 'AzureBastionSubnet'
} 

// AzureBastionSubnet is required to deploy Bastion service. This subnet must exist in the parsubnets array if you enable Bastion Service.
// There is a minimum subnet requirement of /27 prefix.  
// If you are deploying standard this needs to be larger. https://docs.microsoft.com/en-us/azure/bastion/configuration-settings#subnet
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
                      id: modBastionPublicIp.outputs.outPublicIpID
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

module modGatewayPublicIP '../reusable/public-ip/public-ip.bicep' = [for (gateway,i) in parGatewayArray:{
  name: 'deploy-Gateway-Public-Ip-${i}'
  params: {
    parPublicIpName: '${gateway.name}-PublicIp'
    location: resourceGroup().location
    parPublicIpProperties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
    }
    parPublicIpSku: {
        name: parPublicIPSku
    }
    parTags: parTags
  }
}]

//Minumum subnet size is /27 supporting documentation https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsub
resource resGateway 'Microsoft.Network/virtualNetworkGateways@2021-02-01' = [for (gateway,i) in parGatewayArray: {
  name: gateway.name
  location: resourceGroup().location
  tags: parTags
  properties:{
    activeActive: gateway.activeActive
    enableBgp: gateway.enableBgp
    enableBgpRouteTranslationForNat: gateway.enableBgpRouteTranslationForNat
    enableDnsForwarding: gateway.enableDnsForwarding
    bgpSettings: (gateway.enableBgp) ? gateway.bgpSettings : null
    gatewayType: gateway.gatewayType
    vpnGatewayGeneration: (gateway.gatewayType == 'VPN') ? gateway.generation : 'None'
    vpnType: gateway.vpntype
    sku:{
      name: gateway.sku  
      tier: gateway.sku
    }
    ipConfigurations:[
      {
        id: resHubVirtualNetwork.id
        name: 'vnetGatewayConfig'
        properties:{
          publicIPAddress:{
            id: modGatewayPublicIP[i].outputs.outPublicIpID
          }
          subnet:{
            id: resGatewaySubnetRef.id
          }
        }
      }
    ]
  }
}]


resource resAzureFirewallSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: resHubVirtualNetwork
  name: 'AzureFirewallSubnet'
} 


module modAzureFirewallPublicIP '../reusable/public-ip/public-ip.bicep' = if(parAzureFirewallEnabled){
  name: 'deploy-Firewall-Public-Ip'
  params: {
    parPublicIpName: '${parAzureFirewallName}-PublicIp'
    location: resourceGroup().location
    parPublicIpProperties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
    }
    parPublicIpSku: {
        name: parPublicIPSku
    }
    parTags: parTags
  }
}

// AzureFirewallSubnet is required to deploy Azure Firewall . This subnet must exist in the parsubnets array if you deploy.
// There is a minimum subnet requirement of /26 prefix.  
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
            id: modAzureFirewallPublicIP.outputs.outPublicIpID
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

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
resource resHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if(parAzureFirewallEnabled) {
  name: parHubRouteTableName
  location: resourceGroup().location
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default-azfw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAzureFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: pardisableBgpRoutePropagation
  }
}


resource resPrivateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [for privateDnsZone in parPrivateDnsZones: if(parPrivateDNSZonesEnabled) {
  name: privateDnsZone
  location: 'global'
  tags: parTags
}]

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
output outAzureFirewallPrivateIP string = parAzureFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
output outAzureFirewallName string = parAzureFirewallEnabled ? parAzureFirewallName : ''

output outPrivateDnsZones array = [for i in range(0,length(parPrivateDnsZones)): {
  name: resPrivateDnsZones[i].name
  id: resPrivateDnsZones[i].id
}]

output outDdosPlanResourceId string = resDdosProtectionPlan.id
