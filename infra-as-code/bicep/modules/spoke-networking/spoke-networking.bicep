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
param parAzureFirewallEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled')
param parDdosEnabled bool = true

@description('Tags you would like to be applied to all resources in this module')
param parTags object = {}

@description('Id of the DdosProtectionPlan which will be applied to the Virtual Network.  Default: Empty String')
param parDdosProtectionPlanId string = ''

@description('The IP address range for all virtual networks to use.')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@description('Prefix Used for Hub Network')
param parSpokeNetworkPrefix string = 'Corp-Spoke'

@description('The name and IP address range for each subnet in the virtual networks.')
param parSubnets array = [
  {
    name: 'frontend'
    ipAddressRange: '10.11.5.0/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.11.10.0/24'
  }
]

//@description('Private DNS Zones.  Array of Name and Id of Zones')
//param parPrivateDNSZones array = []

@description('Firewall Ip Address')
param parFirewallIPAddress string = ''

@description('Name of Route table to create for the default route of Hub. Default: udr-spoke-to-hub')
param parSpoketoHubRouteTableName string = 'udr-spoke-to-hub'


var varSubnetProperties = [for subnet in parSubnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
    routeTable: {
      id: resSpoketoHubRouteTable.id
    }
  }
}]

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
    subnets: varSubnetProperties
    enableDdosProtection: parDdosEnabled
    ddosProtectionPlan: (parDdosEnabled) ? {
      id: parDdosProtectionPlanId
      } : null
    dhcpOptions: (parAzureFirewallEnabled) ? {
      dnsServers: [ 
        parFirewallIPAddress 
      ]
    }:null  
  }
}

resource resSpoketoHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if(parAzureFirewallEnabled) {
  name: parSpoketoHubRouteTableName
  location: resourceGroup().location
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAzureFirewallEnabled ? parFirewallIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}

output outSpokeVirtualNetworkName string = resSpokeVirtualNetwork.name
output outSpokeVirtualNetworkid string = resSpokeVirtualNetwork.id
