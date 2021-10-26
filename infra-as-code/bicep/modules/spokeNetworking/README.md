# Module: Spoke Networking

This module defines spoke networking based on the recommendations from the Azure Landing Zone Conceptual Architecture. If enabled spoke will route traffic to Hub Network with NVA.

Module deploys the following resources:
  * VirtualNetwork(Spoke VNet)
  * Subnets
  * UDR - if Firewall is enabled
  * Private DNS Link


## Parameters

The module requires the following inputs:

 Parameter | Type | Default | Description | Requirement | Example
----------- | ---- | ------- |----------- | ----------- | -------
 parHubNVAEnabled | bool| true | Switch to enable use of NVA for Hub. Creates route table and associated route for 0.0.0.0/0 to point to provided parNextHopIpAddress | None | true
 parDdosEnabled  | bool | true | Switch to enable DDoS on VNet | None | true
 parNetworkDnsEnableProxy | bool | true | Switch to enable Network DNS Proxy on VNet | None | true
 parBGPRoutePropogation | bool | false | Switch to enable BGP Route Propogation on VNet | None | false
 parTags | object| empty array | Array of Tags to be applied to all resources in the Spoke Network | None | 
 parDdosProtectionPlanId | string | Empty String | Existing DDoS Protection plan to utilize| Valid DDoS Plan ID | 
 parSpokeNetworkAddressPrefix | string | '10.11.0.0/16' | CIDR for Spoke Network | Valid CIDR for Spoke Network | '10.11.0.0/16' 
 parSpokeNetworkPrefix | string | Corp-Spoke | Name Prefix which will be leveraged when creating VNet |  2-50 char  | Corp-Spoke
 parDNSServerIPArray | array | empty array | Array IP DNS Servers to use for VNet DNS Resolution | None | None
 parNextHopIPAddress | string | empty string | IP Address where network traffic should route to leverage DNS Proxy | 192.168.50.1
 parSpokeToHubRouteTableName | string | udr-spoke-to_hub | Name of Route table to create for the default route of Hub. |udr-spoke-to_hub

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------
outSpookeVirtualNetworkName | string | Corp-Spoke-eastus
outSpokeVirtualNetworkid | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxxx-xxxxxxxxx/resourceGroups/net-core-hub-eastus-rg/providers/Microsoft.Network/virtualNetworks/vnet-hub-eastus

## Deployment
Module is intended to be called from other modules as a reusable resource.

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")






