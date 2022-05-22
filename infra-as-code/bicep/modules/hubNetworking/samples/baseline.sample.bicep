//
// Baseline deployment sample
//

// Use this sample to deploy a Well-Architected aligned resource configuration.

targetScope = 'resourceGroup'

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

@description('Baseline resource configuration')
module baseline_hub_network '../hubNetworking.bicep' = {
  name: 'baseline_hub_network'
  params: {
    parLocation: location
    parPublicIPSku: 'Standard'
  }
}
