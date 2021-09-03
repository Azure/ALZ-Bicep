/*
SUMMARY: Module to deploy create a public Ip address
DESCRIPTION: The following components will be options in this deployment
              Public Ip Address
AUTHOR/S: aultt
VERSION: 1.0.0
*/

@description('Name of Public Ip to create in Azure. Default:None')
param parPublicIpName string

@description('Public Ip Address SKU. Default: None')
param parPublicIpSku object

@description('Properties of Public Ip to be deployed. Default: None')
param parPublicIpProperties object

@description('Azure Region to deploy Public Ip Address to. Default: Current Resource Group')
param location string = resourceGroup().location

@description('Tags to be applied to resource when deployed.  Default: None')
param parTags object

resource resPublicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name: parPublicIpName
  tags: parTags
  location: location
  sku: parPublicIpSku
  properties: parPublicIpProperties
}

output outPublicIpID string = resPublicIp.id


