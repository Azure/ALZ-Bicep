# Module:  Virtual WAN

This module is used to deploy the Virtual WAN network topology and its components according to the Azure Landing Zone conceptual architecture which can be found [here](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology). This module draws parity with the Enterprise Scale implementation in the ARM template [here](https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vwan-connectivity.json).

Module deploys the following resources which can be configured by parameters:

- Virtual WAN
- Virtual Hub. The virtual hub is a prerequisite to connect to either a VPN Gateway, an ExpressRoute Gateway or an Azure Firewall to the virtual WAN
- VPN Gateway
- ExpressRoute Gateway
- Azure Firewall
- Azure Firewall policy
- DDoS Network Protection Plan
- Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> [https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)

## Parameters

- [Parameters for Azure Commercial Cloud](generateddocs/vwanConnectivity.bicep.md)

> **NOTE:**
> - Within the `parVirtualWanHubs` parameter, the following keys (parVpnGatewayCustomName, parExpressRouteGatewayCustomName, parAzFirewallCustomName, and parVirtualWanHubCustomName) can be added to create custom names for the associated resources.
>
> - Although there are generated parameter markdowns for Azure Commercial Cloud, this same module can still be used in Azure China. Example parameter are in the [parameters](./parameters/) folder.
>
> - The file `parameters/vwanConnectivity.parameters.az.all.json` contains parameter values for SKUs that are compatible with availability zones for relevant resource types. In cases where you are deploying to a region that does not support availability zones, you should opt for the `parameters/vwanConnectivity.parameters.all.json` file.
>

<!-- markdownlint-disable -->
> - When deploying using the `parameters/vwanConnectivity.parameters.all.json` you must update the `parPrivateDnsZones` parameter by replacing the `xxxxxx` placeholders with the deployment region. Failure to do so will cause these services to be unreachable over private endpoints.
> For example, if deploying to East US the following zone entries:
>    - `privatelink.xxxxxx.azmk8s.io`
>    - `privatelink.xxxxxx.backup.windowsazure.com`
>    - `privatelink.xxxxxx.batch.azure.com`
>
>     Will become:
>    - `privatelink.eastus.azmk8s.io`
>    - `privatelink.eastus.backup.windowsazure.com`
>    - `privatelink.eastus.batch.azure.com`
<!-- markdownlint-restore -->

## Outputs

The module will generate the following outputs:

| Output                | Type   | Example                                                                                                                                                                                                  |
| --------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| outVirtualWanName     | string | alz-vwan-eastus                                                                                                                                                                                          |
| outVirtualWanId       | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualWans/alz-vwan-eastus                                                               |
| outVirtualHubName     | string | alz-vhub-eastus                                                                                                                                                                                          |
| outVirtualHubId       | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/virtualHubs/alz-vhub-eastus                                                               |
| outDdosPlanResourceId | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-vwan-eastus/providers/Microsoft.Network/ddosProtectionPlans/alz-ddos-plan                                                         |
| outPrivateDnsZones        | array  | `[{"name":"privatelink.azurecr.io","id":"/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/net-lz-spk-eastus-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"},{"name":"privatelink.azurewebsites.net","id":"/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/net-lz-spk-eastus-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"}]` |
| outPrivateDnsZonesNames  | array  | `["privatelink.azurecr.io", "privatelink.azurewebsites.net"]` |

## Deployment

In this example, the resources required for Virtual WAN connectivity will be deployed to the resource group specified. According to the Azure Landing Zone Conceptual Architecture, the Virtual WAN resources should be deployed into the Platform connectivity subscription. During the deployment step, we will take parameters provided in the example parameters file.

 | Azure Cloud    | Bicep template         | Input parameters file                             |
 | -------------- | ---------------------- | ------------------------------------------------- |
 | Global regions | vwanConnectivity.bicep | parameters/vwanConnectivity.parameters.all.json    |
 | China regions  | vwanConnectivity.bicep | parameters/mc-vwanConnectivity.parameters.all.json |

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# For Azure global regions
# Set Platform connectivity subscription ID as the the current subscription
ConnectivitySubscriptionId="[your platform connectivity subscription ID]"
az account set --subscription $ConnectivitySubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
TopLevelMGPrefix="alz"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-vwanConnectivityDeploy-${dateYMD}"
GROUP="rg-$TopLevelMGPrefix-vwan-001"
TEMPLATEFILE="infra-as-code/bicep/modules/vwanConnectivity/vwanConnectivity.bicep"
PARAMETERS="@infra-as-code/bicep/modules/vwanConnectivity/parameters/vwanConnectivity.parameters.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location eastus

az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
```
OR
```bash
# For Azure China regions
# Set Platform connectivity subscription ID as the the current subscription
ConnectivitySubscriptionId="[your platform connectivity subscription ID]"
az account set --subscription $ConnectivitySubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
TopLevelMGPrefix="alz"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-vwanConnectivityDeploy-${dateYMD}"
GROUP="rg-$TopLevelMGPrefix-vwan-001"
TEMPLATEFILE="infra-as-code/bicep/modules/vwanConnectivity/vwanConnectivity.bicep"
PARAMETERS="@infra-as-code/bicep/modules/vwanConnectivity/parameters/mc-vwanConnectivity.parameters.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location chinaeast2

az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell
# For Azure global regions
# Set Platform connectivity subscription ID as the the current subscription
$ConnectivitySubscriptionId = "[your platform connectivity subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
$TopLevelMGPrefix = "alz"

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-vwanConnectivityDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = "rg-$TopLevelMGPrefix-vwan-001"
  TemplateFile          = "infra-as-code/bicep/modules/vwanConnectivity/vwanConnectivity.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/vwanConnectivity/parameters/vwanConnectivity.parameters.all.json"
}


New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location 'EastUs'

New-AzResourceGroupDeployment @inputObject
```
OR
```powershell
# For Azure China regions
# Set Platform connectivity subscription ID as the the current subscription
$ConnectivitySubscriptionId = "[your platform connectivity subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
$TopLevelMGPrefix = "alz"

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-vwanConnectivityDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = "rg-$TopLevelMGPrefix-vwan-001"
  TemplateFile          = "infra-as-code/bicep/modules/vwanConnectivity/vwanConnectivity.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/vwanConnectivity/parameters/mc-vwanConnectivity.parameters.all.json"
}

New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location 'chinaeast2'

New-AzResourceGroupDeployment @inputObject
  ```
## Example Output in Azure global regions

![Example Deployment Output](media/exampleDeploymentOutputConnectivity.png "Example Deployment Output in Azure global regions")

![Example Virtual WAN Deployment Output](media/exampleDeploymentOutput.png "Example Virtual WAN Deployment Output in Azure global regions")

## Example Output in Azure China regions
![Example Deployment Output](media/mc-exampleDeploymentOutputConnectivity.png "Example Deployment Output in Azure China")

![Example Virtual WAN Deployment Output](media/mc-exampleDeploymentOutput.png "Example Virtual WAN Deployment Output in Azure China")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
