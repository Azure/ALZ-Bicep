/*
SUMMARY: Module to deploy a resource group to the subscription specified. 
DESCRIPTION: The following components will be required parameters in this deployment
    parResourceGroupLocation
    parResourceGroupName
AUTHOR/S: aultt
VERSION: 1.0.0
*/

targetScope = 'subscription'

@description('Azure Region where Resource Group will be created.  No Default')
param parResourceGroupLocation string

@description('Name of Resource Group to be created.  No Default')
param parResourceGroupName string

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = 'b6718c54-b49e-4748-a466-88e3d7c789c8'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: parResourceGroupLocation
  name: parResourceGroupName
}

module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(subscription().subscriptionId, parResourceGroupName)}'
  params: {}
}
