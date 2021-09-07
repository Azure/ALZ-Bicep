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

resource resPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name: parPublicIPName
  tags: parTags
  location: location
  sku: parPublicIPSku
  properties: parPublicIPProperties
}

output outPublicIPID string = resPublicIP.id


