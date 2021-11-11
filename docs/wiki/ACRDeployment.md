<!-- markdownlint-disable -->
## Azure Landing Zones - Private/Organizational Azure Container Registry Deployment (also known as private registry for Bicep modules)
<!-- markdownlint-restore -->

This document outlines the prerequisites, dependencies and flow to setup a Private/Organizational Azure Container Registry.  Once deployed, you can then upload the modules contained within this repository, and deploy.

## Prerequisites

1. Azure Active Directory Tenant.
2. Minimum 1 subscription.  Subscription(s) are required when configuring `Azure Container Registry` services.
3. Deployment Identity with `Contributor` permission to the subscription.

## Deployment Flow

1. Clone Bicep Azure Landing Zone Github repository
    - git `clone https://githubcom/Azure/ALZ-Bicep.git`
2. Login to Azure leveraging PowerShell or CLI
    - **PowerShell**: `Connect-AzAccount`
    - **CLI**: `az login`
3. Select Azure Subscription to deploy Container Registry to
4. Create Resource Group
5. Call Bicep template to create Azure Container Registry
6. Loop through infra-az-code/bicep/modules folders and call bicep publish

## Provided automation

Two scripts exist which automated steps 3-6.
* [Powershell](../scripts/createRGandcallBicep.ps1)
* [Azure CLI](../scripts/createRGandcallBicep.sh)

## Deployment
Prior to executing your desired script, steps one and two need to be complete, and the two variables should be reviewed in the script.
* Variables exist on line 2 and 3 and should be updated to match your desired resource group and region
* Execute script with following commands:
    - **PowerShell**: ./docs/scripts/createRGandcallBicep.ps1
    - **CLI**: ./docs/scripts/createRGandcallBicep.sh


