/*
SUMMARY: Module to deploy ALZ Spoke Network 
DESCRIPTION: The following components will be options in this deployment
              VirtualNetwork(Spoke Vnet)
              Subnets
              UDR - if Firewall is enabled
              Private DNS Link
AUTHOR/S: aultt
VERSION: 1.0.1
  - Changed default value of parNetworkDNSEnableProxy to false. Defaulting to false allow for testing on its own 
  - Changed default value of parDdosEnabled to false. Defaulting to false to allow for testing on its own
*/


@description('Switch which allows Azure Firewall deployment to be disabled')
param parHubNVAEnabled bool = false

@description('Switch which allows DDOS deployment to be disabled')
param parDdosEnabled bool = false

@description('Switch which allows DNS Proxy to be disabled')
param parNetworkDNSEnableProxy bool = false

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

@description('Array of DNS Server IP addresses.  No Default Value')
param parDNSServerIPArray array = []

@description('IP Address where network traffic should route to leveraged with DNS Proxy.  No Default Value')
param parNextHopIPAddress string = ''

@description('Name of Route table to create for the default route of Hub. Default: udr-spoke-to-hub')
param parSpoketoHubRouteTableName string = 'udr-spoke-to-hub'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '0c428583-f2a1-4448-975c-2d6262fd193a'

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
    dhcpOptions: (parNetworkDNSEnableProxy) ? {
      dnsServers: parDNSServerIPArray 
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
          nextHopType: parNetworkDNSEnableProxy ? 'VirtualAppliance' : 'Internet'
          nextHopIpAddress: parNetworkDNSEnableProxy ? parNextHopIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: parBGPRoutePropogation
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().id)}'
  params: {}
}

output outSpokeVirtualNetworkName string = resSpokeVirtualNetwork.name
output outSpokeVirtualNetworkid string = resSpokeVirtualNetwork.id
