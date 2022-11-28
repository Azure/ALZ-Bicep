# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Specifies the location for resources.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies the location for resources.

- Default value: `eastus`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/spokeNetworking/samples/minimum.sample.json"
    },
    "parameters": {
        "location": {
            "value": "eastus"
        }
    }
}
```
