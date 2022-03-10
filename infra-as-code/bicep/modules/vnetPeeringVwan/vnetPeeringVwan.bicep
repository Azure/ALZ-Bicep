/*
SUMMARY: Module to deploy spoke network peered with the Virtual WAN virtual hub as per the Azure Landing Zone conceptual architecture - https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology. This module draws parity with the Enterprise Scale implementation defined in https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vwan-connectivity.json
DESCRIPTION: The following Azure resources will be deployed in a single resource group, all of which can be configured using the parameters file:
            Spoke virtual network
            Virtual network peering with Virtual WAN
AUTHOR/S: Fai Lai @faister
VERSION: 1.0.0
*/

@description('Prefix value which will be prepended to all resource names. Default: alz')
param parCompanyPrefix string = 'alz'

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Region in which the resource group was created. Default: {resourceGroup().location}')
param parLocation string = resourceGroup().location

@description('Prefix Used for Spoke virtual network. Default: {parCompanyPrefix}-vnet-{parLocation}')
param parSpokeNetworkName string = '${parCompanyPrefix}-vnet-${parLocation}'

@description('The IP address range in CIDR notation for the spoke VNET to use. Default: 10.110.0.0/24')
param parSpokeNetworkAddressPrefix string = '10.110.0.0/24'

@description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDNSServerIPArray array = []

@description('Virtual WAN Azure resource ID. Default: Empty String')
param parVwanResourceId string = ''

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '7b5e6db2-1e8c-4b01-8eee-e1830073a63d'

var varVwanHubName = split(parVwanResourceId, '/')[8]

var varVnetPeeringVwanName = '${varVwanHubName}/${parSpokeNetworkName}/'

//If Ddos parameter is true Ddos will be Enabled on the Virtual Network
//If Azure Firewall is enabled and Network Dns Proxy is enabled dns will be configured to point to AzureFirewall
resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = if (!empty(parVwanResourceId)) {
  name: parSpokeNetworkName
  location: parLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        parSpokeNetworkAddressPrefix
      ]
    }
    dhcpOptions: (!empty(parDNSServerIPArray) ? true : false) ? {
      dnsServers: parDNSServerIPArray
    } : null
  }
}

resource resVnetPeeringVwan 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-05-01' = if (!empty(parVwanResourceId)) {
  name: varVnetPeeringVwanName
  properties: {
    remoteVirtualNetwork: {
      id: resSpokeVirtualNetwork.id
    }
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(parLocation)}'
  params: {}
}

// Output VNET peering name and Resource ID
output outVnetPeeringVwanName string = resVnetPeeringVwan.name
output outVnetPeeringVwanResourceId string = resVnetPeeringVwan.id
