# Module: Spoke Networking

This module defines spoke networking based on the recommendations from the Azure Landing Zone Conceptual Architecture. If enabled spoke will route traffic to Hub Network with NVA.

Module deploys the following resources:

- Virtual Network (Spoke VNet)
- Subnets
- UDR - if Firewall is enabled
- Private DNS Link

## Parameters

The module requires the following inputs:

 | Parameter                    | Type   | Default            | Description                                                         | Requirement | Example                                                                                                                                               |
 | ---------------------------- | ------ | ------------------ | ------------------------------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
 | parBGPRoutePropagation       | bool   | false              | Switch to enable BGP Route Propagation on VNet Route Table          | None        | false                                                                                                                                                 |
 | parTags                      | object | Empty object `{}`  | Array of Tags to be applied to all resources in the Spoke Network   | None        | `{"key": "value"}`                                                                                                                                    |
 | parDdosProtectionPlanId      | string | Empty string `''`  | Existing DDoS Protection plan to utilize                            | None        | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/ddosProtectionPlans/alz-Ddos-Plan` |
 | parSpokeNetworkAddressPrefix | string | '10.11.0.0/16'     | CIDR for Spoke Network                                              | None        | '10.11.0.0/16'                                                                                                                                        |
 | parSpokeNetworkName          | string | 'vnet-spoke'       | The Name of the Spoke Virtual Network.                              | None        | 'vnet-spoke'                                                                                                                                          |
 | parDNSServerIPArray          | array  | Empty array `[]`   | Array IP DNS Servers to use for VNet DNS Resolution                 | None        | `['10.10.1.4', '10.20.1.5']`                                                                                                                          |
 | parNextHopIPAddress          | string | Empty string `''`  | IP Address where network traffic should route to leverage DNS Proxy | None        | '192.168.50.4'                                                                                                                                        |
 | parSpokeToHubRouteTableName  | string | 'rtb-spoke-to-hub' | Name of Route table to create for the default route of Hub.         | None        | 'rtb-spoke-to-hub '                                                                                                                                   |
 | parTelemetryOptOut           | bool   | false              | Set Parameter to true to Opt-out of deployment telemetry            | None        | false                                                                                                                                                 |

## Outputs

The module will generate the following outputs:

| Output                      | Type   | Example                                                                                                                                             |
| --------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| outSpookeVirtualNetworkName | string | Corp-Spoke-eastus                                                                                                                                   |
| outSpokeVirtualNetworkid    | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxxx-xxxxxxxxx/resourceGroups/net-core-hub-eastus-rg/providers/Microsoft.Network/virtualNetworks/vnet-hub-eastus |

## Deployment

Module is intended to be called from other modules as a reusable resource.

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")






