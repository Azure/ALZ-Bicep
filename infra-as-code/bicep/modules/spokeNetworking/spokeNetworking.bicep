/*
SUMMARY: Module to deploy ALZ Spoke Network 
DESCRIPTION: The following components will be options in this deployment
              VirtualNetwork(Spoke Vnet)
              Subnets
              UDR - if Firewall is enabled
              Private DNS Link
AUTHOR/S: aultt, jtracey93
VERSION: 1.2.0
  - Changed default value of parNetworkDNSEnableProxy to false. Defaulting to false allow for testing on its own 
  - Changed default value of parDdosEnabled to false. Defaulting to false to allow for testing on its own
  - Added parSpokeNetworkName to allow customer input flexibility
  - Removed unrequired bool switches
*/

@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param parLocation string = resourceGroup().location

@description('Switch which allows BGP Route Propagation to be disabled on the route table')
param parBGPRoutePropagation bool = false

@description('Tags you would like to be applied to all resources in this module')
param parTags object = {}

@description('Id of the DdosProtectionPlan which will be applied to the Virtual Network.  Default: Empty String')
param parDdosProtectionPlanId string = ''

@description('The IP address range for all virtual networks to use.')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@description('The Name of the Spoke Virtual Network. Default: vnet-spoke')
param parSpokeNetworkName string = 'vnet-spoke'

@description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDNSServerIPArray array = []

@description('IP Address where network traffic should route to leveraged with DNS Proxy. Default: Empty String')
param parNextHopIPAddress string = ''

@description('Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub')
param parSpoketoHubRouteTableName string = 'rtb-spoke-to-hub'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '0c428583-f2a1-4448-975c-2d6262fd193a'

//If Ddos parameter is true Ddos will be Enabled on the Virtual Network
//If Azure Firewall is enabled and Network Dns Proxy is enabled dns will be configured to point to AzureFirewall
resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: parSpokeNetworkName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parSpokeNetworkAddressPrefix
      ]
    }
    enableDdosProtection: (!empty(parDdosProtectionPlanId) ? true : false)
    ddosProtectionPlan: (!empty(parDdosProtectionPlanId) ? true : false) ? {
      id: parDdosProtectionPlanId
    } : null
    dhcpOptions: (!empty(parDNSServerIPArray) ? true : false) ? {
      dnsServers: parDNSServerIPArray
    } : null
  }
}

resource resSpoketoHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if (!empty(parNextHopIPAddress)) {
  name: parSpoketoHubRouteTableName
  location: parLocation
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default-to-hub-nva'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parNextHopIPAddress
        }
      }
    ]
    disableBgpRoutePropagation: parBGPRoutePropagation
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().id)}'
  params: {}
}

output outSpokeVirtualNetworkName string = resSpokeVirtualNetwork.name
output outSpokeVirtualNetworkid string = resSpokeVirtualNetwork.id
