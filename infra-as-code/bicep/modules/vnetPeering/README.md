# Module: VNet Peering

This module creates a virtual network peering connection between two virtual networks and is to be utilized by other modules. Module will need to be called twice to create the completed peering.  Each time with a peering direction. This allows for peering between different subscriptions.

**Peering Options Documentation:**

- [https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering)
- [https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#create-a-peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#create-a-peering)

Module deploys the following resources:

- Virtual Network Peering

> Consider using the `hubPeeredSpoke` orchestration module instead to simplify spoke networking deployment, VNET Peering, UDR configuration and Subscription placement in a single module. [infra-as-code/bicep/orchestration/hubPeeredSpoke](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/hubPeeredSpoke)

## Parameters

- [Link to Parameters](generateddocs/vnetPeering.bicep.md)

## Outputs

The module will generate the following outputs:

| Output | Type | Example |
| ------ | ---- | ------- |

## Deployment

In this example, the remote spoke VNet will be peered with the Hub VNet in the Connectivity subscription.

> Note that the example configures the peering only one way, to complete the peering you will need to repeat the process with a separate parameter file with reverse parameters.

During the deployment step, we will take parameters provided in the example parameters file.

 | Azure Cloud    | Bicep template      | Input parameters file                    |
 | -------------- | ------------------- | ---------------------------------------- |
 | All  regions | vnetPeering.bicep | parameters/vnetPeering.parameters.all.json    |

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
**NOTE: As there is some PowerShell code within the CLI, there is a requirement to execute the deployments in a cross-platform terminal which has PowerShell installed.**
```bash
# For Azure global regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
LandingZoneSubscriptionId="[your Landing Zone subscription ID]"
az account set --subscription $LandingZoneSubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
TopLevelMGPrefix="alz"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-vnetPeeringDeploy-${dateYMD}"
GROUP="rg-$TopLevelMGPrefix-vnet-peering-001"
TEMPLATEFILE="infra-as-code/bicep/modules/vnetPeering/vnetPeering.bicep"
PARAMETERS="@infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location eastus

az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
```
OR
```bash
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
LandingZoneSubscriptionId="[your Landing Zone subscription ID]"
az account set --subscription $LandingZoneSubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
TopLevelMGPrefix="alz"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-vnetPeeringDeploy-${dateYMD}"
GROUP="rg-$TopLevelMGPrefix-vnet-peering-001"
TEMPLATEFILE="infra-as-code/bicep/modules/vnetPeering/vnetPeering.bicep"
PARAMETERS="@infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location chinaeast2

az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell
# For Azure global regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
$LandingZoneSubscriptionId = "[your Landing Zone subscription ID]"

Select-AzSubscription -SubscriptionId $LandingZoneSubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
$TopLevelMGPrefix = "alz"

# Create Resource Group - optional when using an existing resource group
New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location eastus

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-vnetPeeringDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = "rg-$TopLevelMGPrefix-vnet-peering-001"
  TemplateFile          = "ALZ-Bicep/infra-as-code/bicep/modules/vnetPeering/vnetPeering.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json"
}

New-AzResourceGroupDeployment @inputObject
```
OR
```powershell
# For Azure China regions
# Set your Corp Connected Landing Zone subscription ID as the the current subscription
$LandingZoneSubscriptionId = "[your Landing Zone subscription ID]"

Select-AzSubscription -SubscriptionId $LandingZoneSubscriptionId

# Create Resource Group - optional when using an existing resource group
New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location chinaeast2

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
$TopLevelMGPrefix = "alz"

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-vnetPeeringDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = "rg-$TopLevelMGPrefix-vnet-peering-001"
  TemplateFile          = "ALZ-Bicep/infra-as-code/bicep/modules/vnetPeering/vnetPeering.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json"
}

New-AzResourceGroupDeployment @inputObject
```

## Example output in Azure global regions

![Example Deployment Output](media/exampleDeploymentOutput.png "Example Deployment Output in Azure global regions")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
