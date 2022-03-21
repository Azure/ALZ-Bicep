/*
SUMMARY: Module to deploy spoke network peered with the Virtual WAN virtual hub as per the Azure Landing Zone conceptual architecture - https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology. This module draws parity with the Enterprise Scale implementation defined in https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vwan-connectivity.json
DESCRIPTION: The following Azure resources will be deployed in a single resource group, all of which can be configured using the parameters file:
            Spoke virtual network
            Virtual network peering with Virtual WAN virtual hub
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

@description('Virtual Hub resource ID. Default: Empty String')
param parVirtualHubResourceId string = ''

@description('Remote Spoke virtual network resource ID. Default: Empty String')
param parRemoteVirtualNetworkResourceId string = ''

@description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDNSServerIPArray array = []

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '7b5e6db2-1e8c-4b01-8eee-e1830073a63d'

var varVwanSubscriptionId = split(parVirtualHubResourceId, '/')[2]

var varVwanResourceGroup = split(parVirtualHubResourceId, '/')[4]

resource resNewSpokeVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = if (empty(parRemoteVirtualNetworkResourceId) && !empty(parVirtualHubResourceId)) {
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

// The hubVirtualNetworkConnection resource is implemented as a separate module because the deployment scope could be on a different subscription and resource group
module modhubVirtualNetworkConnection 'hubVirtualNetworkConnection.bicep' = if (!empty(parVirtualHubResourceId)) {
  scope: resourceGroup(varVwanSubscriptionId, varVwanResourceGroup)  
  name: 'deploy-Vnet-Peering-Vwan'
  params: {
    parVirtualHubResourceId: parVirtualHubResourceId
    parRemoteVirtualNetworkResourceId: !empty(parRemoteVirtualNetworkResourceId) ? parRemoteVirtualNetworkResourceId : resNewSpokeVnet.id
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(parLocation)}'
  params: {}
}

output outHubVirtualNetworkConnectionName string = modhubVirtualNetworkConnection.name
output outHubVirtualNetworkConnectionResourceId string = modhubVirtualNetworkConnection.outputs.outHubVirtualNetworkConnectionResourceId
