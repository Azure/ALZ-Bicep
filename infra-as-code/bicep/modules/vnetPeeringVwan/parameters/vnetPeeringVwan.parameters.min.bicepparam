using '../vnetPeeringVwan.bicep'

param parVirtualWanHubResourceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualHubs/alz-vhub-eastus'

param parRemoteVirtualNetworkResourceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/spokevnet-rg/providers/Microsoft.Network/virtualNetworks/vnet-spoke'

param parTelemetryOptOut = false