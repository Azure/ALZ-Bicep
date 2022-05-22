//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

@description('Minimum resource configuration')
module minimum_public_ip '../publicIp.bicep' = {
  name: 'minimum_public_ip'
  params: {
    parPublicIPName: 'pip-minimum-ip'
    parLocation: location
    parPublicIPProperties: { }
    parPublicIPSku: {
      name: 'Basic'
      tier: 'Regional'
    }
    parTags: {}
  }
}
