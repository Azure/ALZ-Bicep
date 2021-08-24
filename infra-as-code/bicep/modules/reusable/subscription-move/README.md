Module:  Move Subscription

Move a subscription from it's original management group to a new management group.  Once the subscription is moved, Azure Policies assigned to the new management group or it's parent management group(s) will begin to govern the subscription.

## Parameters

The module requires the following required input parameters.

 Paramenter | Type | Description | Requirement | Example
----------- | ---- | ----------- | ----------- | -------
parSubscriptionId | string | Subscription Id that should be moved to a new management group. | Mandatory input | `34b63c8f-1782-42e6-8fb9-ba6ee8b99735`
parTargetManagementGroupId | string | Target management group for the subscription. | Mandatory input, management group must exist | `alz-platform-connectivity` |

## Outputs

*This module does not produce any outputs.*


## Deployment

In this example, the subscription `34b63c8f-1782-42e6-8fb9-ba6ee8b99735` will be moved to `alz-platform-connectivity` management group.  The parameters are defined in `subscription-move.parameters.example.json`.

### Azure CLI
```bash
az deployment mg create \
  --template-file infra-as-code/bicep/modules/reusable/subscription-move/subscription-move.bicep \
  --parameters @infra-as-code/bicep/modules/reusable/subscription-move/subscription-move.parameters.example.json \
  --location eastus \
  --management-group-id alz
```

### PowerShell

```powershell
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/reusable/subscription-move/subscription-move.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/reusable/subscription-move/subscription-move.parameters.example.json `
  -Location eastus `
  -ManagementGroupId alz
```

## Bicep Visualizer

![Bicep Visualizer](media/bicep-visualizer.png "Bicep Visualizer")
