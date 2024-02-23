<!-- markdownlint-disable -->
## How Does ALZ-Bicep Implement resilient deployments across availability zones?
<!-- markdownlint-restore -->

## Overview

[Azure availability zones](https://learn.microsoft.com/azure/reliability/availability-zones-overview) are essential for resiliency as they offer distinct physical locations within an Azure region, each with independent power, cooling, and networking. By distributing applications across availability zones, businesses can ensure high availability and fault tolerance, minimizing downtime and mitigating the impact of potential failures. This architecture enhances resilience by safeguarding against data center-level outages and providing redundancy for critical workloads, ultimately enabling uninterrupted service delivery and maintaining business continuity.

In the `ALZ-Bicep` project we provide the ability to deploy [resources that support zonal configuration](https://learn.microsoft.com/azure/reliability/availability-zones-service-support) in supported regions into [availability zones](https://learn.microsoft.com/azure/well-architected/reliability/regions-availability-zones) to allow for a more resilient deployment of the landing zone platform resources.

## What are the Azure services in ALZ-Bicep that support zonal configuration ?

- Azure Firewall (Microsoft.Network/azureFirewalls)
- ExpressRoute Gateway (Microsoft.Network/expressRouteGateways)
- Public IP Address (Microsoft.Network/publicIPAddresses)
- Virtual Network Gateway (Microsoft.Network/virtualNetworkGateways)

## How to deploy supported platform services in a zonal configuration ?

All of the services that support zonal configuration are located in either the *hubNetworking* or the *vwanConnectivity* module. A sample parameters file for each module is provided to provide the required availability zones for those resources to be deployed in a zonal configuration.

### hubNetworking.bicep

In this module, you have the option to deploy the Azure Firewall, Virtual Network Gateway or the ExpressRoute Gateway into a zonal configuration.

- You will need to edit the *parameters/hubNetworking.parameters.az.all.json* file to provide the zones supported by the region you are deploying to for the following parameters:

  - **parAzFirewallAvailabilityZones**
  - **parAzErGatewayAvailabilityZones**
  - **parAzVpnGatewayAvailabilityZones**

> **NOTE:**
> The zonal configuration of Public IP addresses is automatically configured if the associated resource is deployed into an zonal configuration.

```json
"parAzFirewallAvailabilityZones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    },
    "parAzErGatewayAvailabilityZones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    },
    "parAzVpnGatewayAvailabilityZones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    }
```

- Follow the [guidance](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/hubNetworking#deployment) in the *hubNetworking.bicep* module to deploy the module using *parameters/hubNetworking.parameters.az.all.json* parameters file.

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
PARAMETERS="@infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.az.all.json"

az group create --location eastus \
   --name $GROUP

az deployment group create --name ${NAME:0:63} --resource-group $GROUP --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell
# For Azure global regions
# Set Platform connectivity subscription ID as the the current subscription
$ConnectivitySubscriptionId = "[your platform connectivity subscription ID]"

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

# Set Platform management subscription ID as the the current subscription
$ManagementSubscriptionId = "[your platform management subscription ID]"

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
$TopLevelMGPrefix = "alz"

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-HubNetworkingDeploy-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = "rg-$TopLevelMGPrefix-hub-networking-001"
  TemplateFile          = "infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep"
  TemplateParameterFile = "infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.az.all.json"
}

New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location 'eastus'

New-AzResourceGroupDeployment @inputObject
```

### vwanConnectivity.bicep

In this module, you have the option to deploy the Azure Firewall into a zonal configuration.

- You will need to edit the *parameters/vwanConnectivity.parameters.az.all.json* file to provide the zones supported by the region you are deploying to for the following parameters:

  - **parAzFirewallAvailabilityZones**

```json
"parAzFirewallAvailabilityZones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    }
```

- Follow the [guidance](https://github.com/sebassem/ALZ-Bicep/tree/alz-resiliency-guidance/infra-as-code/bicep/modules/vwanConnectivity#deployment) in the *vwanConnectivity.bicep* module to deploy the module using *parameters/vwanConnectivity.parameters.az.all.json* parameters file.

<!-- markdownlint-disable -->
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
PARAMETERS="@infra-as-code/bicep/modules/vwanConnectivity/parameters/vwanConnectivity.parameters.az.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location eastus

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
  TemplateParameterFile = "infra-as-code/bicep/modules/vwanConnectivity/parameters/vwanConnectivity.parameters.az.all.json"
}


New-AzResourceGroup `
  -Name $inputObject.ResourceGroupName `
  -Location 'EastUs'

New-AzResourceGroupDeployment @inputObject
```
<!-- markdownlint-restore -->
