/*
SUMMARY: Module to deploy ALZ Hub Network 
DESCRIPTION: The following components will be options in this deployment
              VNET
              Subnets
              VPN Gateway
              ExpressRoute Gateway
              Azure Firewall or 3rd Party NVA
              NSG
              DDOS Plan
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
param parDDOSEnabled bool = true

@description('Switch which allows Azure Firewall deployment to be disabled')
param parAzureFirewallEnabled bool = true

@description('Switch which allows Virtual Network Gateway deployment to be disabled')
param parGatewayEnabled bool = true

@description('Azure SKU or Tier to deploy.  Currently two options exist Basic and Standard')
param parBastionSku string = 'Standard'

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

@description('Virtual Network Gateway Generation to deploy')
@allowed([
  'Generation1'
  'Generation2'
  'None'
])
param parVpnGateGatewayGeneration string = 'Generation2'

@description('Type of virtual Network Gateway')
@allowed([
  'PolicyBased'
  'RouteBased'
])
param parVpnType string ='RouteBased'

@description('Sku/Tier of Virtual Network Gateway to deploy')
param parVpnSku string = 'Basic'

@description('The IP address range for all virtual networks to use.')
param parVirtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('Prefix Used for Hub Network')
param parHubNetworkPrefix string = 'Hub'

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
]

var varSubnetProperties = [for subnet in parSubnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

var varBastionName = 'bastion-${resourceGroup().location}'

var varBastionSubnetRef = '${resVirtualNetworks.id}/subnets/AzureBastionSubnet}'

resource resVirtualNetworks 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${parHubNetworkPrefix}-${resourceGroup().location}'
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes:[
        parVirtualNetworkAddressPrefix
      ]
    }
    subnets: varSubnetProperties
  }
}

resource resBastionPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = if(parBastionEnabled){
  location: resourceGroup().location
  name: '${varBastionName}-PublicIp'
  tags: parTags
  sku: {
      name: parBastionSku
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}

resource resBastion 'Microsoft.Network/bastionHosts@2021-02-01' = if(parBastionEnabled){
  location: resourceGroup().location
  name: varBastionName
  tags: parTags
  properties: {
      dnsName: uniqueString(resourceGroup().id)
      ipConfigurations: [
          {
              name: 'IpConf'
              properties: {
                  subnet: {
                      id: varBastionSubnetRef
                  }
                  publicIPAddress: {
                      id: resBastionPublicIP.id
                  }
              }
          }
      ]
  }
}

/*
resource resExpressRouteGateway 'Microsoft.Network/expressRouteGateways@2021-02-01' = if(parHybridDeploymentOption == 'Express_Route_Gateway'){

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
      id: resVirtualNetworks.id
      name: 'vnetGatewayConfig'
      properties:{
        publicIpAddress:{
          id: ''
        }
        subnet:{
          id: varBastionSubnetRef
        }
      }
    }
  }
}
*/
