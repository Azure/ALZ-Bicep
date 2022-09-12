# Module: Container Registry

This module creates an Azure Container Registry to store private Bicep Modules.

Module deploys the following resources:

- Azure Container Registry

## Parameters

The module requires the following inputs:

 Parameter | Type | Default | Description | Requirement | Example
----------- | ---- | ------- |----------- | ----------- | -------
 parAcrName | string | acr${uniqueString(resourceGroup().id)} | Name of Azure Container Registry to deploy | 5-50 char | acr5cix6w3rcizn
 parACRSku | string | Basic | SKU of Azure Container Registry to deploy to Azure | Basic or Standard or Premium | Basic
 parLocation | string | resourceGroup().location | Location where Public Azure Container Registry will be deployed | Valid Azure Region | eastus2
 parTags | object | none | Tags to be appended to resource | none | {"Environment" : "Development"}

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------
outLoginServer | string | acr5cix6w3rcizna.azurecr.io

## Deployment

In this example, the Azure Container Registry will be deployed to the resource group specified.

We will take the default values and not pass any parameters.

> For the below examples we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
**NOTE: As there is some PowerShell code within the CLI, there is a requirement to execute the deployments in a cross-platform terminal which has PowerShell installed.**

```bash
az group create --location eastus \
   --name Bicep_ACR

$inputObject = @(
'--name',           ('alz-ContainerRegistry-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])),
'--resource-group', 'Bicep_ACR',
'--parameters',     '@infra-as-code/bicep/CRML/containerRegistry/parameters/containerRegistry.parameters.all.json',
'--template-file',  "infra-as-code/bicep/CRML/containerRegistry/containerRegistry.bicep",
)

az deployment group create @inputObject
```

### PowerShell

```powershell
New-AzResourceGroup -Name 'Bicep_ACR' `
  -Location 'EastUs'

  $inputObject = @{
  DeploymentName        = 'alz-ContainerRegistry-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = 'Bicep_ACR'
  TemplateParameterFile = 'infra-as-code/bicep/CRML/containerRegistry/parameters/containerRegistry.parameters.all.json'
  TemplateFile          = "infra-as-code/bicep/CRML/containerRegistry/containerRegistry.bicep"
}

New-AzResourceGroupDeployment @inputObject
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")