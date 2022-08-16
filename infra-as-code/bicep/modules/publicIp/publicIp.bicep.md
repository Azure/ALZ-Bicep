# publicIp

[Azure Landing Zones - Bicep Modules](..)

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Azure Region to deploy Public IP Address to. Default: Current Resource Group
parPublicIpName | Yes      | Name of Public IP to create in Azure. Default: None
parPublicIpSku | Yes      | Public IP Address SKU. Default: None
parPublicIpProperties | Yes      | Properties of Public IP to be deployed. Default: None
parAvailabilityZones | No       | Availability Zones to deploy the Public IP across. Region must support Availability Zones to use. If it does not then leave empty.
parTags        | No       | Tags to be applied to resource when deployed.  Default: None
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Region to deploy Public IP Address to. Default: Current Resource Group

- Default value: `[resourceGroup().location]`

### parPublicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of Public IP to create in Azure. Default: None

### parPublicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Public IP Address SKU. Default: None

### parPublicIpProperties

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Properties of Public IP to be deployed. Default: None

### parAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Public IP across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags to be applied to resource when deployed.  Default: None

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outPublicIpId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/publicIp/publicIp.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parPublicIpName": {
            "value": ""
        },
        "parPublicIpSku": {
            "value": {}
        },
        "parPublicIpProperties": {
            "value": {}
        },
        "parAvailabilityZones": {
            "value": []
        },
        "parTags": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
