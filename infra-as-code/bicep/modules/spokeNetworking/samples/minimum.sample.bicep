

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
    parDnsServerIps: [
      'dns-svr-1'
      'dns-svr-2'
    ] 
    parNextHopIpAddress: '10.10.10.10'

  }
}
