/*
SUMMARY: Module to perform spoke network peering with the Virtual WAN virtual hub as per the Azure Landing Zone conceptual architecture - https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology. This module draws parity with the Enterprise Scale implementation defined in https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vwan-connectivity.json
DESCRIPTION: The peering can be configured using the parameters file:
            Virtual network peering with Virtual WAN virtual hub
AUTHOR/S: Fai Lai @faister
VERSION: 1.0.0
*/

targetScope = 'subscription'

@description('Region in which the resource group was created. Default: {resourceGroup().location}')
param parLocation string = deployment().location

@description('Virtual Hub resource ID. Default: Empty String')
param parVirtualHubResourceId string = ''

@description('Remote Spoke virtual network resource ID. Default: Empty String')
param parRemoteVirtualNetworkResourceId string = ''

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '7b5e6db2-1e8c-4b01-8eee-e1830073a63d'

var varVwanSubscriptionId = split(parVirtualHubResourceId, '/')[2]

var varVwanResourceGroup = split(parVirtualHubResourceId, '/')[4]

// The hubVirtualNetworkConnection resource is implemented as a separate module because the deployment scope could be on a different subscription and resource group
module modhubVirtualNetworkConnection 'hubVirtualNetworkConnection.bicep' = if (!empty(parVirtualHubResourceId) && !empty(parRemoteVirtualNetworkResourceId)) {
  scope: resourceGroup(varVwanSubscriptionId, varVwanResourceGroup)  
  name: 'deploy-Vnet-Peering-Vwan'
  params: {
    parVirtualHubResourceId: parVirtualHubResourceId
    parRemoteVirtualNetworkResourceId: parRemoteVirtualNetworkResourceId
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(parLocation)}'
  params: {}
}

output outHubVirtualNetworkConnectionName string = modhubVirtualNetworkConnection.name
output outHubVirtualNetworkConnectionResourceId string = modhubVirtualNetworkConnection.outputs.outHubVirtualNetworkConnectionResourceId
