@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param parLocation string = resourceGroup().location

@description('Switch to enable/disable BGP Propagation on route table. Default: false')
param parDisableBgpRoutePropagation bool = false

@description('Id of the DdosProtectionPlan which will be applied to the Virtual Network.  Default: Empty String')
param parDdosProtectionPlanId string = ''

@description('The IP address range for all virtual networks to use. Default: 10.11.0.0/16')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@description('The Name of the Spoke Virtual Network. Default: vnet-spoke')
param parSpokeNetworkName string = 'vnet-spoke'

@description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDnsServerIps array = []

@description('IP Address where network traffic should route to leveraged with DNS Proxy. Default: Empty String')
param parNextHopIpAddress string = ''

@description('Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub')
param parSpokeToHubRouteTableName string = 'rtb-spoke-to-hub'

@description('Tags you would like to be applied to all resources in this module. Default: Empty Object')
param parTags object = {}

@description('Set Parameter to true to Opt-out of deployment telemetry. Default: false')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '0c428583-f2a1-4448-975c-2d6262fd193a'

//If Ddos parameter is true Ddos will be Enabled on the Virtual Network
//If Azure Firewall is enabled and Network DNS Proxy is enabled DNS will be configured to point to AzureFirewall
resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: parSpokeNetworkName
  location: parLocation
  tags: parTags
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
    dhcpOptions: (!empty(parDnsServerIps) ? true : false) ? {
      dnsServers: parDnsServerIps
    } : null
  }
}

resource resSpokeToHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if (!empty(parNextHopIpAddress)) {
  name: parSpokeToHubRouteTableName
  location: parLocation
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default-to-hub-nva'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parNextHopIpAddress
        }
      }
    ]
    disableBgpRoutePropagation: parDisableBgpRoutePropagation
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().id)}'
  params: {}
}

output outSpokeVirtualNetworkName string = resSpokeVirtualNetwork.name
output outSpokeVirtualNetworkId string = resSpokeVirtualNetwork.id
