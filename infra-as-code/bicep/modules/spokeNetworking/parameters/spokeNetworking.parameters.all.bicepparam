using '../spokeNetworking.bicep'

param parLocation = 'eastus'

param parDisableBgpRoutePropagation = false

param parDdosProtectionPlanId = ''

param parSpokeNetworkAddressPrefix = '10.11.0.0/16'

param parSpokeNetworkName = 'vnet-spoke'

param parDnsServerIps = []

param parNextHopIpAddress = ''

param parSpokeToHubRouteTableName = 'rtb-spoke-to-hub'

param parTags = {
  Environment: 'Live'
}

param parTelemetryOptOut = false