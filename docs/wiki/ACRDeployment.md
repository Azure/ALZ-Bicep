<!-- markdownlint-disable -->
## Azure Landing Zones - Private/Organizational Azure Container Registry Deployment
<!-- markdownlint-restore -->

This document outlines the prerequisites, dependencies and flow to setup a Private/Organizational Azure Container Registry.

## Prerequisites

1. Azure Active Directory Tenant.
2. Minimum 1 subscription.  Subscription(s) are required when configuring `Azure Container Registry` services.  
3. Deployment Identity with `Contributor` permission to the subscription.  

## Deployment Flow

1. Clone Bicep Azure Landing Zone Github repository
2. Login to Azure leveraging PowerShell or CLI
3. Select Azure Subscription to deploy Container Registry to
4. Create Resource Group
5. Call Bicep template to create Azure Container Registry
6. Loop through infra-az-code/bicep/modules folders and call bicep publish

## Provided automation

Two scripts exist which automated steps 3-6.  
* [Powershell](../scripts/createRGandcallBicep.ps1)
* [Azure CLI](../scripts/createRGandcallBicep.sh)

Prior to updating steps one and two need to be done and the two variables should be reviewed in the script.


