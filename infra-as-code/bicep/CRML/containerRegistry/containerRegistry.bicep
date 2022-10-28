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
@sys.description('Provide a globally unique name of your Azure Container Registry')
param parAcrName string = 'acr${uniqueString(resourceGroup().id)}'

@sys.description('Provide a location for the registry.')
param parLocation string = resourceGroup().location

@sys.description('Provide a tier of your Azure Container Registry.')
param parAcrSku string = 'Basic'

@sys.description('Tags to be applied to resource when deployed.  Default: None')
param parTags object ={}

resource resAzureContainerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
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

@sys.description('Output the login server property for later use')
output outLoginServer string = resAzureContainerRegistry.properties.loginServer

