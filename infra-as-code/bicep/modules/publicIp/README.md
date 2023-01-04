# Module: Public IP

This module defines a public IP address and outputs the id for other modules to consume.

Module deploys the following resources:

- Public IP Address

## Parameters

- [Link to Parameters](generateddocs/publicIp.bicep.md)

## Outputs

The module will generate the following outputs:

| Output        | Type   | Example                                                                                                                                                  |
| ------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| outPublicIpId | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/publicIPAddresses/alz-bastion-PublicIp |

## Deployment

Module is intended to be called from other modules as a reusable resource.

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
