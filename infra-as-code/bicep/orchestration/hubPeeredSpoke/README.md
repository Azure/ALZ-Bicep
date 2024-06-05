# Module: Orchestration - hubPeeredSpoke - Spoke network, including peering to Hub (Hub & Spoke or Virtual WAN)

> [!IMPORTANT]
> We recommend utilizing the [Bicep Landing Zone Vending Module](https://github.com/Azure/bicep-lz-vending) in place of this Spoke Networking Module. Not only does the module handle spoke networking, but it also handles many other aspects of setting up the > foundational components of the application landing zones which are out of scope for this module.


This module acts as an orchestration module that create and configures a spoke network to deliver the Azure Landing Zone Hub & Spoke architecture, for both traditional Hub & Spoke and Virtual WAN, which is also described in the wiki on the [Deployment Flow article](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow).

Module deploys the following resources:

- Subscription placement in Management Group hierarchy - if parPeeredVnetSubscriptionMgPlacement is specified
- Resource group
- Virtual Network (Spoke VNet)
- UDR - if parNextHopIPAddress and resource id of hub virtual network object is specified
- Hub to Spoke peering - if resource id of hub virtual network object is specified in parHubVirtualNetworkID
- Spoke to hub peering - if resource id of hub virtual network object is specified in parHubVirtualNetworkID
- Spoke to virtual WAN peering - if resource id of virtual WAN hub object is specified in parHubVirtualNetworkID

Note that only one peering type can be created with this module, so either traditional Hub & Spoke **OR** Azure virtual WAN.

<!-- markdownlint-disable -->
> You can use this module to enable Landing Zones (aka Subscriptions) with platform resources, as defined above, and also place them into the correct location in the hierarchy to meet governance requirements. For example, you can also use this module to deploy the Identity Landing Zone Subscription's vNet and peer it back to the hub vNet.
>
> You could also use it in a [loop](https://learn.microsoft.com/azure/azure-resource-manager/bicep/loops) to enable multiple Landing Zone Subscriptions at a time in a single deployment.
<!-- markdownlint-restore -->

## Parameters

- [Parameters for Azure Commercial Cloud](generateddocs/hubPeeredSpoke.bicep.md)

## Outputs

The module will generate the following outputs:

| Output                      | Type   | Example                                                                                                                                             |
| --------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| outSpokeVirtualNetworkName  | string | `vnet-spoke`                                                                                                                                        |
| outSpokeVirtualNetworkId    | string | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxxx-xxxxxxxxx/resourceGroups/Hub_Networking_POC/providers/Microsoft.Network/virtualNetworks/vnet-spoke`        |

## Deployment

This module is intended to be called from other modules as a reusable resource, but an example on how to deploy has been added below for completeness.

In this example, the spoke resources will be deployed to the resource group specified. According to the Azure Landing Zone Conceptual Architecture, the spoke resources should be deployed into the Landing Zones subscriptions. During the deployment step, we will take the parameters provided in the example parameter files.

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI

```bash
# For Azure global regions

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-HubPeeredSpoke-${dateYMD}"
LOCATION="eastus"
MGID="alz"
TEMPLATEFILE="infra-as-code/bicep/orchestration/hubPeeredSpoke/hubPeeredSpoke.bicep"
PARAMETERS="@infra-as-code/bicep/orchestration/hubPeeredSpoke/parameters/hubPeeredSpoke.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS
```
OR
```bash
# For Azure China regions

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-HubPeeredSpoke-${dateYMD}"
LOCATION="chinaeast2"
MGID="alz"
TEMPLATEFILE="infra-as-code/bicep/orchestration/hubPeeredSpoke/hubPeeredSpoke.bicep"
PARAMETERS="@infra-as-code/bicep/orchestration/hubPeeredSpoke/parameters/hubPeeredSpoke.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell
# For Azure global regions

$inputObject = @{
  DeploymentName        = 'alz-HubPeeredSpoke-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'EastUS'
  ManagementGroupId     = 'alz'
  TemplateFile          = "infra-as-code/bicep/orchestration/hubPeeredSpoke/hubPeeredSpoke.bicep"
  TemplateParameterFile = 'infra-as-code/bicep/orchestration/hubPeeredSpoke/parameters/hubPeeredSpoke.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject
```
OR
```powershell
# For Azure China regions

$inputObject = @{
  DeploymentName        = 'alz-HubPeeredSpoke-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'chinaeast2'
  ManagementGroupId     = 'alz'
  TemplateFile          = "infra-as-code/bicep/orchestration/hubPeeredSpoke/hubPeeredSpoke.bicep"
  TemplateParameterFile = 'infra-as-code/bicep/orchestration/hubPeeredSpoke/parameters/hubPeeredSpoke.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")






