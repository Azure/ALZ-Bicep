# Module:  VNet Peering with vWAN

This module is used to deploy virtual network peering with the Virtual WAN virtual hub. This network topology is based on the Azure Landing Zone conceptual architecture which can be found [here](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology) and the hub-spoke network topology with Virtual WAN [here](https://docs.microsoft.com/en-us/azure/architecture/networking/hub-spoke-vwan-architecture). Once peered, virtual networks exchange traffic by using the Azure backbone network. Virtual WAN enables transitivity among hubs which is not possible solely by using peering. This module draws parity with the Enterprise Scale implementation in the ARM template [here](https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vnetPeeringVwan.json).

Module deploys the following resources which can be configured by parameters:

- Spoke virtual network
- Virtual network peering with Virtual WAN virtual hub

## Parameters

The module requires the following inputs:

 | Parameter                    | Type   | Default                                                                                              | Description                                                                                                                                                                                                                                                         | Requirement                   | Example                      |
 | ---------------------------- | ------ | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ---------------------------- |
 | parCompanyPrefix             | string | alz                                                                                                  | Prefix value which will be pre-appended to all resource names                                                                                                                                                                                                       | 1-10 char                     | alz                          |
 | parTags                      | object | Empty Array []                                                                                       | List of tags (Key Value Pairs) to be applied to resources                                                                                                                                                                                                           | None                          | environment: 'POC'   |
 | parLocation           | string | resourceGroup().location | Location where spoke virtual network will be deployed        | Valid Azure Region | `westus`                         |
 | parSpokeNetworkName          | string | ${parCompanyPrefix}-spokevnet-${resourceGroup().location}                                                  | Name prefix for spoke virtual network.  Prefix will be appended with the region.                                                                                                                                                                                          | 2-50 char                     | alz-spokevnet-westus              |
 | parSpokeNetworkAddressPrefix   | string | 10.110.0.0/24                                                                                         | CIDR range for the spoke virtual network                                                                                                                                                                                                                                           | CIDR Notation                 | 10.110.0.0/24                 |
 | parVirtualHubResourceId        | string | Empty string                                                  | Name prefix for spoke virtual network.  Prefix will be appended with the region.                                                                                                                                                                                          | 2-50 char                     | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualHubs/alz-vhub-eastus              |
 | parDNSServerIPArray          | array  | Empty array `[]`           | Array IP DNS Servers to use for VNet DNS Resolution                 | None        | `['10.10.1.4', '10.20.1.5']`                                                                                                                          |
 | parTelemetryOptOut           | bool   | false                                                                                                | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                                                                                                            | None                          | false                        |

## Outputs

The module will generate the following outputs:

| Output                    | Type   | Example                                                                                                                                                                                                  |
| ------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| outSpokeVnetName | string | alz-vnet-westus                                                                                                                                                                                            |
| outSpokeVnetResourceId      | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-spokevnet-westus/providers/Microsoft.Network/virtualNetworks/alz-vnet-westus                                                                                                                                                                                          |
| outHubVirtualNetworkConnectionResourceId | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualHubs/alz-vhub-eastus/hubVirtualNetworkConnections/alz-vnet-westus                                                                                                                                                                                            |
## Deployment

In this example, the resources required for spoke Vnet and its peering with the Vwan Virtual Hub will be deployed to the resource group specified. According to the Azure Landing Zone Conceptual Architecture, the spoke Vnet resources should be deployed into the Corp Connected Landing Zone subscription. During the deployment step, we will take parameters provided in the example parameters file.

 | Azure Cloud    | Bicep template      | Input parameters file                    |
 | -------------- | ------------------- | ---------------------------------------- |
 | All  regions | vnetPeeringVwan.bicep | vnetPeeringVwan.parameters.example.json    |

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# For Azure global regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription 
CorpConnectedLZSubscriptionId="[your corp connected landing zone subscription ID]"
az account set --subscription $CorpConnectedLZSubscriptionId

az group create --location westus \
   --name alz-spokevnet-westus

az deployment group create \
   --resource-group alz-spokevnet-westus \
   --template-file infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep \
   --parameters @infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json
```
OR
```bash
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription 
CorpConnectedLZSubscriptionId="[your corp connected landing zone subscription ID]"
az account set --subscription $CorpConnectedLZSubscriptionId

az group create --location chinanorth2 \
   --name alz-spokevnet-chinanorth2

az deployment group create \
   --resource-group alz-spokevnet-chinanorth2 \
   --template-file infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep \
   --parameters @infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json
```

### PowerShell

```powershell
# For Azure global regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription 
$CorpConnectedLZSubscriptionId = "[your corp connected landing zone subscription ID]"

Select-AzSubscription -SubscriptionId $CorpConnectedLZSubscriptionId

New-AzResourceGroup -Name 'alz-spokevnet-westus' `
  -Location 'WestUs'
  
New-AzResourceGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json `
  -ResourceGroupName 'alz-spokevnet-westus'
```
OR
```powershell
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription 
$CorpConnectedLZSubscriptionId = "[your corp connected landing zone subscription ID]"

Select-AzSubscription -SubscriptionId $CorpConnectedLZSubscriptionId

New-AzResourceGroup -Name 'alz-spokevnet-chinanorth2' `
  -Location 'chinanorth2'
  
New-AzResourceGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.parameters.example.json `
  -ResourceGroupName 'alz-spokevnet-chinanorth2'
```
## Example Output in Azure global regions

![Example Deployment Output](media/vnetPeeringVwanExampleDeploymentOutput.png "Example Deployment Output in Azure global regions")

## Bicep Visualizer

![Bicep Visualizer](media/vnetPeeringVwanBicepVisualizer.png "Bicep Visualizer")
