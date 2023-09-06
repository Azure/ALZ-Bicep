<!-- markdownlint-disable -->
## Azure Landing Zones - Private/Organizational Azure Container Registry Deployment (also known as private registry for Bicep modules)
<!-- markdownlint-restore -->

This document outlines the prerequisites, dependencies and flow to setup a Private/Organizational Azure Container Registry.  Once deployed, you can then upload the modules contained within this repository, and deploy.

> This is based on the official Bicep docs here: [Create private registry for Bicep modules](https://learn.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry)

## Prerequisites

1. Microsoft Entra Tenant.
2. Minimum 1 subscription.  Subscription(s) are required when configuring `Azure Container Registry` services.
3. Deployment Identity with `Contributor` permission to the subscription.

## Deployment Flow

1. Clone Bicep Azure Landing Zone Github repository
    - `git clone https://github.com/Azure/ALZ-Bicep.git`
2. Login to Azure leveraging PowerShell or CLI
    - **PowerShell**: `Connect-AzAccount`
    - **CLI**: `az login`
3. Select Azure Subscription to deploy Container Registry to
    - **PowerShell:** `Select-AzSubscription -SubscriptionId 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'`
    - **CLI:** `az account set --subscription 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'`
4. Create Resource Group
5. Call Bicep template to create Azure Container Registry
6. Loop through infra-az-code/bicep/modules folders and call `bicep publish` for each bicep module in this repo

## Provided automation

Two scripts exist which automate steps 4 to 6.
* [PowerShell](https://github.com/Azure/ALZ-Bicep/blob/main/docs/scripts/createRGandcallBicep.ps1)
* [Azure CLI](https://github.com/Azure/ALZ-Bicep/blob/main/docs/scripts/createRGandcallBicep.sh)

## Deployment
Prior to executing your desired script, steps one and two need to be complete, and the two variables should be reviewed in the script.
* Variables exist on lines 3 and 4 of each script and should be updated to match your desired resource group and region.
* Execute script with following commands:
  - **PowerShell**: `./docs/scripts/createRGandcallBicep.ps1`
  - **CLI**: `./docs/scripts/createRGandcallBicep.sh`
