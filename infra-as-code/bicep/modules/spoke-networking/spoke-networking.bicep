/*
SUMMARY: Module to deploy ALZ Spoke Network 
DESCRIPTION: The following components will be options in this deployment
              VirtualNetwork(Spoke Vnet)
              Subnets
              UDR - if Firewall is enabled
              Private DNS Link
AUTHOR/S: aultt
VERSION: 1.0.0
*/


@description('Switch which allows Azure Firewall deployment to be disabled')
param parHubNVAEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled')
param parDdosEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled')
param parNetworkDnsEnableProxy bool = true

@description('Switch which allows BGP Route Propogation to be disabled')
param parBGPRoutePropogation bool = false

@description('Tags you would like to be applied to all resources in this module')
param parTags object = {}

@description('Id of the DdosProtectionPlan which will be applied to the Virtual Network.  Default: Empty String')
param parDdosProtectionPlanId string = ''

@description('The IP address range for all virtual networks to use.')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@description('Prefix Used for Spoke Network')
param parSpokeNetworkPrefix string = 'Corp-Spoke'

@description('Array of Dns Server Ip addresses.  No Default Value')
param parDnsServerIpArray array 

@description('Ip Address where network traffic should route to leveraged with DnsProxy.  No Default Value')
param parNextHopIPAddress string 

@description('Name of Route table to create for the default route of Hub. Default: udr-spoke-to-hub')
param parSpoketoHubRouteTableName string = 'udr-spoke-to-hub'

//If Ddos parameter is true Ddos will be Enabled on the Virtual Network
//If Azure Firewall is enabled and Network Dns Proxy is enabled dns will be configured to point to AzureFirewall
resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${parSpokeNetworkPrefix}-${resourceGroup().location}'
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes:[
        parSpokeNetworkAddressPrefix
      ]
    }
    enableDdosProtection: parDdosEnabled
    ddosProtectionPlan: (parDdosEnabled) ? {
      id: parDdosProtectionPlanId
      } : null
    dhcpOptions: (parNetworkDnsEnableProxy) ? {
      dnsServers: parDnsServerIpArray 
    }:null  
  }
}

resource resSpoketoHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if(parHubNVAEnabled) {
  name: parSpoketoHubRouteTableName
  location: resourceGroup().location
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default-to-hub-nva'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parNetworkDNSEnableProxy ? parNextHopIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: parBGPRoutePropogation
  }
}

output outSpokeVirtualNetworkName string = resSpokeVirtualNetwork.name
output outSpokeVirtualNetworkid string = resSpokeVirtualNetwork.id
