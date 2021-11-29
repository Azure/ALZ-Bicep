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
param parResourceGroupLocation string = 'australiaeast'

@description('Name of Resource Group to be created.  No Default')
param parResourceGroupName string = 'testrg'

var cuaId = 'e3fdbe9a-4816-4dc5-993c-a74d3e3761b4'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: parResourceGroupLocation
  name: parResourceGroupName
}

module pid '../customerUsageAttribution/cuaId.bicep' = {
  name: '${cuaId}-${deployment().location}'
  params: {}
}
