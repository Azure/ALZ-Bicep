metadata name = 'ALZ Bicep - Virtual Network Lock creation module'
metadata description = 'Module used to create a resource lock for an Virtual Networks'

@sys.description('Resource name')
param parResourceName string

@sys.description('Resource Lock Configuration Object')
param parResourceLockConfig object

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '8b09c163-b878-482d-b237-13248e17fdcd'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: parResourceName
}

resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  scope: virtualNetwork
  name: '${parResourceName}-lock'
  properties: {
    level: parResourceLockConfig.level
    notes: parResourceLockConfig.notes
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location, parResourceName)}'
  params: {}
}
