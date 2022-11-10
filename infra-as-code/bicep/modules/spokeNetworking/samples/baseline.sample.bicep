
//
// baseline deployment sample
//

// Use this sample to deploy the baseline resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
// ----------
@description('Specifies the location for resources.')
param location string = 'eastus'
// ---------
// RESOURCES
// ---------

@description('baseline resource configuration.')
module spoke_nw '../spokeNetworking.bicep' = {
  name: 'spoke_nw'
  params: {
    parLocation: location
    parDisableBgpRoutePropagation: false
    parSpokeNetworkAddressPrefix: '10.1.0.0/16'
    parSpokeNetworkName: 'spoke'
    parDdosProtectionPlanId: 'ddosProtectionPlanId'
    parSpokeToHubRouteTableName: 'spokeToHubRouteTable'
    parTelemetryOptOut: false
    parTags: {
      Environment: 'Dev'
      CostCenter: 'IT'
    }
    parDnsServerIps: [
      '10.1.1.100'
      '10.1.1.101'
    ]
    parNextHopIpAddress: '10.1.0.10'

  }
}
