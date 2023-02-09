# Module:  VNet Peering with vWAN

This module is used to perform virtual network peering with the Virtual WAN virtual hub. This network topology is based on the Azure Landing Zone conceptual architecture which can be found [here](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology) and the hub-spoke network topology with Virtual WAN [here](https://learn.microsoft.com/en-us/azure/architecture/networking/hub-spoke-vwan-architecture). Once peered, virtual networks exchange traffic by using the Azure backbone network. Virtual WAN enables transitivity among hubs which is not possible solely by using peering. This module draws parity with the Enterprise Scale implementation in the ARM template [here](https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vnetPeeringVwan.json).

Module deploys the following resources which can be configured by parameters:

- Virtual network peering with Virtual WAN virtual hub

> Consider using the `hubPeeredSpoke` orchestration module instead to simplify spoke networking deployment, VNET Connection to VWAN Hub (Peering), UDR configuration and Subscription placement in a single module. [infra-as-code/bicep/orchestration/hubPeeredSpoke](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/hubPeeredSpoke)

## Parameters

- [Parameters for Virtual Network Peering from vWAN](generateddocs/vnetPeeringVwan.bicep.md)
- [Parameters for Hub Virtual Network Connectivity from vWAN](generateddocs/hubVirtualNetworkConnection.bicep.md)

## Outputs

The module will generate the following outputs:

| Output                    | Type   | Example                                                                                                                                                                                                  |
| ------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| outHubVirtualNetworkConnectionName | string | `alz-vhub-eastus/vnet-spoke-vhc`                                                                                                                                                                                            |
| outHubVirtualNetworkConnectionResourceId      | string | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualHubs/alz-vhub-eastus/hubVirtualNetworkConnections/vnet-spoke-vhc`                                                                                                                                                                                          |

## Deployment

In this example, the remote spoke Vnet will be peered with the Vwan Virtual Hub in the Connectivity subscription. During the deployment step, we will take parameters provided in the example parameters file.

 | Azure Cloud    | Bicep template      | Input parameters file                    |
 | -------------- | ------------------- | ---------------------------------------- |
 | All  regions | vnetPeeringVwan.bicep | parameters/vnetPeeringVwan.parameters.all.json    |

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI

```bash
# For Azure global regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
ConnectivitySubscriptionId="[your Landing Zone subscription ID]"
az account set --subscription $ConnectivitySubscriptionId

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-vnetPeeringVwanDeployment-${dateYMD}"
LOCATION="eastus"
TEMPLATEFILE="infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep"
PARAMETERS="@infra-as-code/bicep/modules/vnetPeeringVwan/parameters/vnetPeeringVwan.parameters.all.json"

az deployment sub create --name ${NAME:0:63} --location $LOCATION --template-file $TEMPLATEFILE --parameters $PARAMETERS
```
OR
```bash
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
ConnectivitySubscriptionId="[your Landing Zone subscription ID]"
az account set --subscription $ConnectivitySubscriptionId

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-vnetPeeringVwanDeployment-${dateYMD}"
LOCATION="chinaeast2"
TEMPLATEFILE="infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep"
PARAMETERS="@infra-as-code/bicep/modules/vnetPeeringVwan/parameters/vnetPeeringVwan.parameters.all.json"

az deployment sub create --name ${NAME:0:63} --location $LOCATION --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell
# For Azure global regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
$ConnectivitySubscriptionId = "[your Landing Zone subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

$inputObject = @{
  DeploymentName        = 'alz-VnetPeeringWanDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'eastus'
  TemplateFile          = "infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep"
  TemplateParameterFile = 'infra-as-code/bicep/modules/vnetPeeringVwan/parameters/vnetPeeringVwan.parameters.all.json'
}

New-AzDeployment @inputObject

```
OR
```powershell
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
$ConnectivitySubscriptionId = "[your Landing Zone subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

$inputObject = @{
  DeploymentName        = 'alz-VnetPeeringWanDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'chinaeast2'
  TemplateFile          = "infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep"
  TemplateParameterFile = 'infra-as-code/bicep/modules/vnetPeeringVwan/parameters/vnetPeeringVwan.parameters.all.json'
}

New-AzDeployment @inputObject
```
## Example Output in Azure global regions

![Example Deployment Output](media/exampleDeploymentOutput.png "Example Deployment Output in Azure global regions")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
