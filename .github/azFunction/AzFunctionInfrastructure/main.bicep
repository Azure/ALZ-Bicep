@description('Azure region to deploy in')
param parLocation string = resourceGroup().location

@description('Azure Function App Name')
param parAzFunctionName string = uniqueString(resourceGroup().id)

@description('Azure Storage Account Name')
param parStorageAccountName string = uniqueString(resourceGroup().id)

@description('App Service Plan Name')
param parApplicationServicePlanName string = 'FunctionPlan'

@description('Application Insights Name')
param parApplicationInsightsName string = 'AppInsights'

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: parStorageAccountName
  location: parLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource resApplicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: parApplicationInsightsName
  location: parLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource resApplicationServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: parApplicationServicePlanName
  location: parLocation
  kind: 'functionapp,linux'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

resource resAzFunction 'Microsoft.Web/sites@2021-03-01' = {
  name: parAzFunctionName
  location: parLocation
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resApplicationServicePlan.id
    enabled: true
    reserved: true
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${resStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(resStorageAccount.id, resStorageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${resStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(resStorageAccount.id, resStorageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'denyfunctionb051f2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: resApplicationInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powerShell'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
    }
    httpsOnly: true
  }
}
