using '../spokeNetworking.bicep'

param parDisableBgpRoutePropagation = false

param parDdosProtectionPlanId = ''

param parSpokeNetworkAddressPrefix = '10.11.0.0/16'

param parDnsServerIps = []

param parNextHopIpAddress = ''

param parTelemetryOptOut = false