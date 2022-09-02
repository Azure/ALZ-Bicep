//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------

@description('The Azure location to deploy to.')
param location string = resourceGroup().location

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration')
module minimum_public_ip '../publicIp.bicep' = {
  name: 'minimum_public_ip'
  params: {
    parPublicIpName: 'pip-minimum-ip'
    parLocation: location
    parPublicIpProperties: { }
    parPublicIpSku: {
      name: 'Basic'
      tier: 'Regional'
    }
    parTags: {}
  }
}
