/*
SUMMARY: Module to deploy create a public IP address
DESCRIPTION: The following components will be options in this deployment
              Public IP Address
AUTHOR/S: aultt
VERSION: 1.0.0
*/

@description('Name of Public IP to create in Azure. Default: None')
param parPublicIPName string

@description('Public IP Address SKU. Default: None')
param parPublicIPSku object

@description('Properties of Public IP to be deployed. Default: None')
param parPublicIPProperties object

@description('Azure Region to deploy Public IP Address to. Default: Current Resource Group')
param location string = resourceGroup().location

@description('Tags to be applied to resource when deployed.  Default: None')
param parTags object

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '3f85b84c-6bad-4c42-86bf-11c233241c22'

resource resPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name: parPublicIPName
  tags: parTags
  location: location
  sku: parPublicIPSku
  properties: parPublicIPProperties
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location, parPublicIPName)}'
  params: {}
}

output outPublicIPID string = resPublicIP.id


