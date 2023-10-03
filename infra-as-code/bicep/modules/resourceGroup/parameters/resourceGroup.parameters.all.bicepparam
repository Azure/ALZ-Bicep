using '../resourceGroup.bicep'

param parLocation = 'eastus'

param parResourceGroupName = 'alz-rg'

param parTags = {
  Environment: 'Live'
}

param parTelemetryOptOut = false
