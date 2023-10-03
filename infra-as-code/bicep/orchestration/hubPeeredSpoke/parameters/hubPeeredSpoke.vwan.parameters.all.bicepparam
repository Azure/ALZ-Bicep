using '../hubPeeredSpoke.bicep'

param parLocation = 'westeurope'

param parTopLevelManagementGroupPrefix = 'alz'

param parTopLevelManagementGroupSuffix = ''

param parPeeredVnetSubscriptionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parPeeredVnetSubscriptionMgPlacement = 'alz-platform-connectivity'

param parDdosProtectionPlanId = ''

param parSpokeNetworkName = 'vnet-spoke'

param parSpokeNetworkAddressPrefix = '10.202.0.0/24'

param parDnsServerIps = []

param parNextHopIpAddress = '10.20.255.4'

param parDisableBgpRoutePropagation = false

param parSpoketoHubRouteTableName = 'rtb-spoke-to-hub'

param parHubVirtualNetworkId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-westeurope-hub-networking/providers/Microsoft.Network/virtualHubs/alz-vhub-westeurope'

param parAllowSpokeForwardedTraffic = false

param parAllowHubVPNGatewayTransit = true

param parVirtualHubConnectionPrefix = ''

param parVirtualHubConnectionSuffix = '-vhc'

param parEnableInternetSecurity = false

param parTags = {
  Environment: 'Live'
}

param parTelemetryOptOut = false
