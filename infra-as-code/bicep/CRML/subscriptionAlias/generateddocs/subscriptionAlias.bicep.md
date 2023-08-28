# ALZ Bicep CRML - Subscription Alias Module

Module to deploy an Azure Subscription into an existing billing scope that can be from an EA, MCA or MPA

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parSubscriptionName | Yes      | Name of the subscription to be created. Will also be used as the alias name. Whilst you can use any name you like we recommend it to be: all lowercase, no spaces, alphanumeric and hyphens only.
parSubscriptionBillingScope | Yes      | The full resource ID of billing scope associated to the EA, MCA or MPA account you wish to create the subscription in.
parTags        | No       | Tags you would like to be applied.
parManagementGroupId | No       | The ID of the existing management group where the subscription will be placed. Also known as its parent management group. (Optional)
parSubscriptionOwnerId | No       | The object ID of a responsible user, Microsoft Entra group or service principal. (Optional)
parSubscriptionOfferType | No       | The offer type of the EA, MCA or MPA subscription to be created. Defaults to = Production
parTenantId    | No       | The ID of the tenant. Defaults to = tenant().tenantId

### parSubscriptionName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the subscription to be created. Will also be used as the alias name. Whilst you can use any name you like we recommend it to be: all lowercase, no spaces, alphanumeric and hyphens only.

### parSubscriptionBillingScope

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The full resource ID of billing scope associated to the EA, MCA or MPA account you wish to create the subscription in.

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied.

### parManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The ID of the existing management group where the subscription will be placed. Also known as its parent management group. (Optional)

### parSubscriptionOwnerId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The object ID of a responsible user, Microsoft Entra group or service principal. (Optional)

### parSubscriptionOfferType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The offer type of the EA, MCA or MPA subscription to be created. Defaults to = Production

- Default value: `Production`

- Allowed values: `DevTest`, `Production`

### parTenantId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The ID of the tenant. Defaults to = tenant().tenantId

- Default value: `[tenant().tenantId]`

## Outputs

Name | Type | Description
---- | ---- | -----------
outSubscriptionName | string |
outSubscriptionId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/CRML/subscriptionAlias/subscriptionAlias.json"
    },
    "parameters": {
        "parSubscriptionName": {
            "value": ""
        },
        "parSubscriptionBillingScope": {
            "value": ""
        },
        "parTags": {
            "value": {}
        },
        "parManagementGroupId": {
            "value": ""
        },
        "parSubscriptionOwnerId": {
            "value": ""
        },
        "parSubscriptionOfferType": {
            "value": "Production"
        },
        "parTenantId": {
            "value": "[tenant().tenantId]"
        }
    }
}
```
