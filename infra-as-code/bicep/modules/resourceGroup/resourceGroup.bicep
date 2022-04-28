targetScope = 'subscription'

@description('Azure Region where Resource Group will be created.  No Default')
param parLocation string

@description('Name of Resource Group to be created.  No Default')
param parResourceGroupName string

@description('Tags you would like to be applied to all resources in this module')
param parTags object = {}

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = 'b6718c54-b49e-4748-a466-88e3d7c789c8'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: parLocation
  name: parResourceGroupName
  tags: parTags
}

module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(subscription().subscriptionId, parResourceGroupName)}'
  params: {}
}

output outResourceGroupName string = resResourceGroup.name
output outResourceGroupId string = resResourceGroup.id
