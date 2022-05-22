//
// Baseline deployment sample
//

// Use this sample to deploy a Well-Architected aligned resource configuration.

targetScope = 'resourceGroup'

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

@description('Baseline resource configuration')
module baseline_public_ip '../publicIp.bicep' = {
  name: 'baseline_public_ip'
  params: {
    parPublicIPName: 'pip-baseline-ip'
    parLocation: location
    parPublicIPProperties: { }
    parPublicIPSku: {
      name: 'Standard'
      tier: 'Regional'
    }
    parTags: {}
  }
}
