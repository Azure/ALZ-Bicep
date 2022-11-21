//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_logging '../logging.bicep' = {
  name: 'minimum_logging'
  params: {
    parLogAnalyticsWorkspaceLocation: location
    parAutomationAccountLocation: location
  }
}
