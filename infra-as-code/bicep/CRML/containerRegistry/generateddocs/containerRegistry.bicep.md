# ALZ Bicep CRML - Container Registry Module

Module to create an Azure Container Registry to store private Bicep Modules

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parAcrName     | No       | Provide a globally unique name of your Azure Container Registry
parLocation    | No       | Provide a location for the registry.
parAcrSku      | No       | Provide a tier of your Azure Container Registry.
parTags        | No       | Tags to be applied to resource when deployed.  Default: None

### parAcrName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Provide a globally unique name of your Azure Container Registry

- Default value: `[format('acr{0}', uniqueString(resourceGroup().id))]`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Provide a location for the registry.

- Default value: `[resourceGroup().location]`

### parAcrSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Provide a tier of your Azure Container Registry.

- Default value: `Basic`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags to be applied to resource when deployed.  Default: None

## Outputs

Name | Type | Description
---- | ---- | -----------
outLoginServer | string | Output the login server property for later use

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/CRML/containerRegistry/containerRegistry.json"
    },
    "parameters": {
        "parAcrName": {
            "value": "[format('acr{0}', uniqueString(resourceGroup().id))]"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parAcrSku": {
            "value": "Basic"
        },
        "parTags": {
            "value": {}
        }
    }
}
```
