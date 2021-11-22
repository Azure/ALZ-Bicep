/*
SUMMARY: Deploys Private Azure Container Registry to store Bicep modules.
DESCRIPTION:
  Deploys Private Azure Container Registry to store Bicep modules.
    * Azure Container Registry


AUTHOR/S: aultt
VERSION: 1.0.0
*/

@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param parAcrName string = 'acr${uniqueString(resourceGroup().id)}'

@description('Provide a location for the registry.')
param parLocation string = resourceGroup().location

@description('Provide a tier of your Azure Container Registry.')
param parAcrSku string = 'Basic'

@description('Tags to be applied to resource when deployed.  Default: None')
param parTags object ={}

resource resAzureContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: parAcrName
  tags: parTags
  location: parLocation
  sku: {
    name: parAcrSku
  }
  properties: {
    adminUserEnabled: false
  }
}

@description('Output the login server property for later use')
output outLoginServer string = resAzureContainerRegistry.properties.loginServer

