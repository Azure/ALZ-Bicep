# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       |

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `westus`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/vwanConnectivity/samples/baseline.sample.json"
    },
    "parameters": {
        "parLocation": {
            "value": "westus"
        }
    }
}
```
