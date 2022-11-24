

//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
@description('Specifies the location for resources.')
param location string = 'eastus'
// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration.')
module spoke_nw '../spokeNetworking.bicep' = {
  name: 'spoke_nw'
  params: {
    parLocation: location
    parDdosProtectionPlanId: 'ddosProtectionPlanId'
    parSpokeNetworkAddressPrefix: '10.1.0.0/16'
    parDnsServerIps: [
      '10.1.1.100'
      '10.1.1.101'
    ]
    parNextHopIpAddress: '10.10.10.10'

  }
}
