//
// Baseline deployment sample
//

// Use this sample to deploy a Well-Architected aligned resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline_public_ip '../publicIp.bicep' = {
  name: 'baseline_public_ip'
  params: {
    parPublicIpName: 'pip-baseline-ip'
    parLocation: location
    parPublicIpProperties: { }
    parPublicIpSku: {
      name: 'Standard'
      tier: 'Regional'
    }
    parTags: {}
    parAvailabilityZones: [
      '1'
      '2'
      '3'
    ]
  }
}
