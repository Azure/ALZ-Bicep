# Module:  VNet Peering with vWAN

This module is used to perform virtual network peering with the Virtual WAN virtual hub. This network topology is based on the Azure Landing Zone conceptual architecture which can be found [here](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology) and the hub-spoke network topology with Virtual WAN [here](https://docs.microsoft.com/en-us/azure/architecture/networking/hub-spoke-vwan-architecture). Once peered, virtual networks exchange traffic by using the Azure backbone network. Virtual WAN enables transitivity among hubs which is not possible solely by using peering. This module draws parity with the Enterprise Scale implementation in the ARM template [here](https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vnetPeeringVwan.json).

Module deploys the following resources which can be configured by parameters:

- Virtual network peering with Virtual WAN virtual hub

## Parameters

The module requires the following inputs:

 | Parameter                    | Type   | Default                                                                                              | Description                                                                                                                                                                                                                                                         | Requirement                   | Example                      |
 | ---------------------------- | ------ | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ---------------------------- |
 | parVirtualHubResourceId        | string | None                                               | Resource ID for Virtual WAN Hub.                                                                                                                                                                                          | 2-50 char                     | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualHubs/alz-vhub-eastus`              |
| parRemoteVirtualNetworkResourceId        | string | None                                                 | Resource ID for remote spoke virtual network.                                                                                                                                                                                          | 2-50 char                     | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/spokevnet-rg/providers/Microsoft.Network/virtualNetworks/vnet-spoke`              |
 | parTelemetryOptOut           | bool   | `false`                                                                                                | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                                                                                                            | None                          | `false`                        |

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
 | All  regions | vnetPeeringVwan.bicep | vnetPeeringVwan.parameters.example.json    |

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# For Azure global regions
# Set your Connectivity subscription ID as the the current subscription 
$ConnectivitySubscriptionId="[your Connectivity subscription ID]"
az account set --subscription $ConnectivitySubscriptionId

az deployment sub create \
   --template-file infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep \
   --parameters @infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json \
   --location eastus
```
OR
```bash
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription 
$ConnectivitySubscriptionId="[your Connectivity subscription ID]"
az account set --subscription $ConnectivitySubscriptionId

az deployment sub create \
   --template-file infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep \
   --parameters @infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json \
   --location chinaeast2
```

### PowerShell

```powershell
# For Azure global regions
# Set your Connectivity subscription ID as the the current subscription 
$ConnectivitySubscriptionId = "[your Connectivity subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

New-AzDeployment `
  -TemplateFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json `
  -Location 'eastus'
```
OR
```powershell
# For Azure China regions
# Set your Connectivity subscription ID as the the current subscription 
$ConnectivitySubscriptionId = "[your Connectivity subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

New-AzDeployment `
  -TemplateFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json `
  -Location 'chinaeast2'
```
## Example Output in Azure global regions

![Example Deployment Output](media/vnetPeeringVwanExampleDeploymentOutput.png "Example Deployment Output in Azure global regions")

## Bicep Visualizer

![Bicep Visualizer](media/vnetPeeringVwanBicepVisualizer.png "Bicep Visualizer")
