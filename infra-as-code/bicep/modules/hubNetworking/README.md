# Module:  Hub-Networking

This module defines hub networking based on the recommendations from the Azure Landing Zone Conceptual Architecture.

Module deploys the following resources:

- Virtual Network (VNet)
- Subnets
- VPN Gateway/ExpressRoute Gateway
- Azure Firewall
- Azure Firewall Policies
- Private DNS Zones
- DDoS Network Protection Plan
- Bastion
- Route Table

## Parameters

- [Parameters for Azure Commercial Cloud](generateddocs/hubNetworking.bicep.md)

> **NOTE:**
> - Although there are generated parameter markdowns for Azure Commercial Cloud, this same module can still be used in Azure China. Example parameter are in the [parameters](./parameters/) folder.
>
> - The file `parameters/hubNetworking.parameters.az.all.json` contains parameter values for SKUs that are compatible with availability zones for relevant resource types. In cases where you are deploying to a region that does not support availability zones, you should opt for the `parameters/hubNetworking.parameters.all.json` file.
>
> - When deploying using the `parameters/hubNetworking.parameters.all.json` you must update the `parPrivateDnsZones` parameter by replacing the `xxxxxx` placeholders with the deployment region or geo code, for Azure Backup. Failure to do so will cause these services to be unreachable over private endpoints.
>
> For example, if deploying to East US the following zone entries:
> - `privatelink.xxxxxx.azmk8s.io`
> - `privatelink.xxxxxx.backup.windowsazure.com`
> - `privatelink.xxxxxx.batch.azure.com`
>
> Will become:
> - `privatelink.eastus.azmk8s.io`
> - `privatelink.eus.backup.windowsazure.com`
> - `privatelink.eastus.batch.azure.com`
>
> See child module, [`privateDnsZones.bicep` docs](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/privateDnsZones#dns-zones) for more info on how this works

To configure P2S VPN connections edit the vpnClientConfiguration value in the `parVpnGatewayConfig` parameter.

AAD Authentication Example:

```bicep
"vpnClientConfiguration": {
  "vpnClientAddressPool": {
    "addressPrefixes": [
      "172.16.0.0/24"
    ]
  },
  "vpnClientProtocols": [
    "OpenVPN"
  ],
  "vpnAuthenticationTypes": [
    "AAD"
  ],
  "aadTenant": "https://login.microsoftonline.com/{AzureAD TenantID}",
  "aadAudience": "41b23e61-6c1e-4545-b367-cd054e0ed4b4",
  "aadIssuer": "https://sts.windows.net/{AzureAD TenantID}/"
}
```

Replace the values for `aadTenant`, `aadAudience`, and `aadIssuer` as documented [here](https://learn.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant#enable-authentication)

## Outputs

The module will generate the following outputs:

| Output                    | Type   | Example                                                                                                                                                                                                  |
| ------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| outAzFirewallPrivateIp    | string | 192.168.100.1                                                                                                                                                                                            |
| outAzFirewallName         | string | MyAzureFirewall                                                                                                                                                                                          |
| outDdosPlanResourceId     | string | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/ddosProtectionPlans/alz-ddos-plan                                                      |
| outPrivateDnsZones        | array  | `[{"name":"privatelink.azurecr.io","id":"/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/net-lz-spk-eastus-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"},{"name":"privatelink.azurewebsites.net","id":"/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/net-lz-spk-eastus-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"}]` |
| outPrivateDnsZonesNames  | array  | `["privatelink.azurecr.io", "privatelink.azurewebsites.net"]` |
| outHubVirtualNetworkName  | array  | MyHubVirtualNetworkName |
| outHubVirtualNetworkId    | array  | /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/HUB_Networking_POC/providers/Microsoft.Network/virtualNetworks/my-hub-vnet   |

## Deployment
> **Note:** `bicepconfig.json` file is included in the module directory.  This file allows us to override Bicep Linters.  Currently there are two URLs which were removed because of linter warnings.  URLs removed are the following: database.windows.net and core.windows.net

In this example, the hub resources will be deployed to the resource group specified. According to the Azure Landing Zone Conceptual Architecture, the hub resources should be deployed into the Platform connectivity subscription. During the deployment step, we will take the default values and not pass any parameters.

There are two different sets of input parameters; one for deploying to Azure global regions, and another for deploying specifically to Azure China regions. This is due to different private DNS zone names for Azure services in Azure global regions and Azure China. The recommended private DNS zone names are available [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns). Other differences in Azure China regions are as follow:
- DDoS Protection feature is not available. parDdosEnabled parameter is set as false.
- The SKUs available for an ExpressRoute virtual network gateway are Standard, HighPerformance and UltraPerformance. Sku is set as "Standard" in the example parameters file.

 | Azure Cloud    | Bicep template      | Input parameters file                           |
 | -------------- | ------------------- | ----------------------------------------------- |
 | Global regions | hubNetworking.bicep | parameters/hubNetworking.parameters.all.json    |
 | China regions  | hubNetworking.bicep | parameters/mc-hubNetworking.parameters.all.json |

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
NAME="alz-HubNetworkingDeploy-${dateYMD}"
GROUP="rg-$TopLevelMGPrefix-hub-networking-001"
TEMPLATEFILE="infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
PARAMETERS="@infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json"

az group create --location eastus \
   --name $GROUP

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
NAME="alz-HubNetworkingDeploy-${dateYMD}"
GROUP="rg-$TopLevelMGPrefix-hub-networking-001"
TEMPLATEFILE="infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
PARAMETERS="@infra-as-code/bicep/modules/hubNetworking/parameters/mc-hubNetworking.parameters.all.json"

az group create --location chinaeast2 \
   --name $GROUP

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
  DeploymentName        = -join ('alz-HubNetworkingDeploy-{0}' -f (Get-Date -Format 'yyyyMMddTHHMMssffffZ'))[0..63]
  ResourceGroupName     = "rg-$TopLevelMGPrefix-hub-networking-001"
  TemplateFile          = "infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json"
}

New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location 'eastus'

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
  DeploymentName        = -join ('alz-HubNetworkingDeploy-{0}' -f (Get-Date -Format 'yyyyMMddTHHMMssffffZ'))[0..63]
  ResourceGroupName     = "rg-$TopLevelMGPrefix-hub-networking-001"
  TemplateFile          = "infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/hubNetworking/parameters/mc-hubNetworking.parameters.all.json"
}

New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location 'chinaeast2'

New-AzResourceGroupDeployment @inputObject
```
## Example Output in Azure global regions

![Example Deployment Output](media/exampleDeploymentOutput.png "Example Deployment Output in Azure global regions")

## Example Output in Azure China regions
![Example Deployment Output](media/mc-exampleDeploymentOutput.png "Example Deployment Output in Azure China")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")

## Multi-region deployment

To extend your infrastructure to [additional regions](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/considerations/regions), this module can be deployed multiple times with different parameters files to deploy additional hubs in multiple regions. The [vnetPeering module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vnetPeering) can be leveraged to peer the hub networks together across the different regions.

> For the example below, two hubs will be deployed across *eastus* and *westus* regions.

1. Duplicate the [parameters file](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.az.all.json) and create a new file for the first hub in the *eastus* region **hubNetworking.parameters.az.all.eastus.json**.

    > **NOTE:**
    > Some regions do not support availability zones, so the [parameters file](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json) without availability zones should be used. East US supports availability zones which is why the `hubNetworking.parameters.az.all.eastus.json` file is used in this example.

1. Edit the new parameters file with the needed configuration for the *eastus* region.
1. Deploy the `hubNetworking` module to deploy the first hub in the *eastus* region using the new parameters file.

    **Azure CLI (Example: East US Region)**

    ```bash
    # For Azure global regions

    # Set Platform connectivity subscription ID as the the current subscription
    ConnectivitySubscriptionId="[your platform connectivity subscription ID]"

    az account set --subscription $ConnectivitySubscriptionId

    # Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
    TopLevelMGPrefix="alz"

    # Set the region where the hub will be deployed
    location="eastus"

    dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
    NAME="alz-HubNetworkingDeploy-${dateYMD}"
    GROUP="rg-$TopLevelMGPrefix-hub-networking-$location"
    TEMPLATEFILE="infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
    PARAMETERS="@infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.$location.json"

    az group create --location $location \
      --name $GROUP

    az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
    ```

    **PowerShell (Example: East US Region)**

    ```powershell
    # For Azure global regions
    # Set Platform connectivity subscription ID as the the current subscription
    $ConnectivitySubscriptionId = "[your platform connectivity subscription ID]"

    Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

    # Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
    $TopLevelMGPrefix = "alz"

    # Set the region where the hub will be deployed
    $location = "eastus"

    # Parameters necessary for deployment
    $inputObject = @{
      DeploymentName        = 'alz-HubNetworkingDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
      ResourceGroupName     = "rg-$TopLevelMGPrefix-hub-networking-$location "
      TemplateFile          = "infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
      TemplateParameterFile = "infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.$location.json"
    }

    New-AzResourceGroup `
      -Name $inputObject.ResourceGroupName `
      -Location $location

    New-AzResourceGroupDeployment @inputObject
    ```

    Example output in the eastus region:

      ![Example Deployment Output in eastus region](media/exampleDeploymentOutputEastus.png "Example Deployment Output in eastus region")

1. Duplicate the [parameters file](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json) and create a new file for the additional hub in the *westus* region **hubNetworking.parameters.az.all.westus.json**.

    > **NOTE:**
    > West US does not currently support availability zones, so the [parameters file](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json) without availability zones is used in this example.

1. Edit the new parameters file with the needed configuration for the *westus* region.
1. Deploy the `hubNetworking` module to deploy the second hub in the *westus* region using the new parameters file.

    > **NOTE:**
    > If you have set the parameter `parDdosEnabled` to true and deployed a DDoS Network Protection Plan, make sure to set this parameter to false when deploying additional regions to avoid creating multiple plans. You will have to manually enable this plan for the additional hub networks you deploy.

    **Azure CLI (Example: West US Region)**

    ```bash
    # For Azure global regions

    # Set Platform connectivity subscription ID as the the current subscription
    ConnectivitySubscriptionId="[your platform connectivity subscription ID]"

    az account set --subscription $ConnectivitySubscriptionId

    # Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
    TopLevelMGPrefix="alz"

    # Set the region where the hub will be deployed
    location="westus"

    dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
    NAME="alz-HubNetworkingDeploy-${dateYMD}"
    GROUP="rg-$TopLevelMGPrefix-hub-networking-$location"
    TEMPLATEFILE="infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
    PARAMETERS="@infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.$location.json"

    az group create --location $location \
      --name $GROUP

    az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
    ```

    **PowerShell (Example: West US Region)**

    ```powershell
    # For Azure global regions
    # Set Platform connectivity subscription ID as the the current subscription
    $ConnectivitySubscriptionId = "[your platform connectivity subscription ID]"

    Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

    # Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
    $TopLevelMGPrefix = "alz"

    # Set the region where the hub will be deployed
    $location = "westus"

    # Parameters necessary for deployment
    $inputObject = @{
      DeploymentName        = 'alz-HubNetworkingDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
      ResourceGroupName     = "rg-$TopLevelMGPrefix-hub-networking-$location "
      TemplateFile          = "infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
      TemplateParameterFile = "infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.$location.json"
    }

    New-AzResourceGroup `
      -Name $inputObject.ResourceGroupName `
      -Location $location

    New-AzResourceGroupDeployment @inputObject
    ```

    Example output in the westus region

      ![Example Deployment Output in westus region](media/exampleDeploymentOutputwestus.png "Example Deployment Output in westus region")

1. To peer the newly created hubs, the [vnetPeering module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vnetPeering) will be used.

1. Edit the [parameters file](https://github.com/sebassem/ALZ-Bicep/blob/alz-multiple-regions/infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json) of the *vnetPeering* module to specify the source and destination virtual networks.

    > **NOTE:**
    > Module will need to be called twice to create the completed peering. Each time with a peering direction.

    **Azure CLI (Example: East US Region to West US Region)**

    ```bash
    **NOTE: As there is some PowerShell code within the CLI, there is a requirement to execute the deployments in a cross-platform terminal which has PowerShell installed.**
    ```bash
    # For Azure global regions
    # Set Platform connectivity subscription ID as the the current subscription
    connectivitySubscriptionId="[your connectivity subscription ID]"
    az account set --subscription $connectivitySubscriptionId

    # Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
    TopLevelMGPrefix="alz"

    dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
    NAME="alz-vnetPeeringDeploy-${dateYMD}"
    GROUP="rg-alz-hub-networking-eastus" # Specify the name of the resource group of the first hub network.
    TEMPLATEFILE="infra-as-code/bicep/modules/vnetPeering/vnetPeering.bicep"
    PARAMETERS="@infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json"

    az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
    ```

    **PowerShell (Example: East US Region to West US Region)**

    ```powershell
    # For Azure global regions
    # Set Platform connectivity subscription ID as the the current subscription
    $connectivitySubscriptionId = "[your connectivity subscription ID]"

    Select-AzSubscription -SubscriptionId $connectivitySubscriptionId

    # Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
    $TopLevelMGPrefix = "alz"

    # Parameters necessary for deployment
    $inputObject = @{
      DeploymentName        = 'alz-vnetPeeringDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
      ResourceGroupName     = "rg-alz-hub-networking-eastus" # Specify the name of the resource group of the first hub network.
      TemplateFile          = "infra-as-code/bicep/modules/vnetPeering/vnetPeering.bicep"
      TemplateParameterFile = "infra-as-code/bicep/modules/vnetPeering/parameters/vnetPeering.parameters.all.json"
    }

    New-AzResourceGroupDeployment @inputObject
    ```

1. Re-deploy the module again after editing the parameters file to peer the other direction.
