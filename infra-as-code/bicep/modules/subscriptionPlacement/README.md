# Module:  Subscription Placement

This module moves one or more subscriptions to be a child of the specified management group. Once the subscription(s) are moved under the management group, Azure Policies assigned to the management group or its parent management group(s) will begin to govern the subscription(s).

> Consider using the `subPlacementAll` orchestration module instead to simplify Subscription placement across your entire Management Group hierarchy in a single module. [infra-as-code/bicep/orchestration/subPlacementAll](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/subPlacementAll)

## Parameters

The module requires the following required input parameters.

 | Parameter                  | Type            | Description                                                                 | Requirement                                  | Example                                                                                                                                                                                        |
 | -------------------------- | --------------- | --------------------------------------------------------------------------- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
 | parSubscriptionIds         | Array | Array of Subscription Ids that should be moved to the new management group. | Mandatory input, default: `[]`                              | Empty: `[]` or <br />1 Subscription: `["yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"]` or<br />Many Subscriptions: `["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"]` |
 | parTargetManagementGroupId | string          | Target management group for the subscription.                               | Mandatory input, management group must exist | `alz-platform-connectivity`                                                                                                                                                                    |
 | parTelemetryOptOut         | bool            | Set Parameter to true to Opt-out of deployment telemetry                    | Optional input, default: `false`                                         | `false`                                                                                                                                                                                        |

## Outputs
*This module does not produce any outputs.*

## Deployment

In this example, the subscription `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` will be moved to `alz-platform-connectivity` management group. The inputs for this module are defined in `parameters/subscriptionPlacement.parameters.all.json`.

> For the  examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
**NOTE: As there is some PowerShell code within the CLI, there is a requirement to execute the deployments in a cross-platform terminal which has PowerShell installed.**
```bash
# For Azure global regions

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-SubscriptionPlacementDeployment-${dateYMD}"
PARAMETERS="@infra-as-code/bicep/modules/subscriptionPlacement/parameters/subscriptionPlacement.parameters.all.json"
LOCATION="eastus"
MGID="alz"
TEMPLATEFILE="infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.bicep"

az deployment mg create --name ${NAME:0:63} --parameters $PARAMETERS --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE
```
OR
```bash
# For Azure China regions

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-SubscriptionPlacementDeployment-${dateYMD}"
PARAMETERS="@infra-as-code/bicep/modules/subscriptionPlacement/parameters/subscriptionPlacement.parameters.all.json"
LOCATION="chinaeast2"
MGID="alz"
TEMPLATEFILE="infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.bicep"

az deployment mg create --name ${NAME:0:63} --parameters $PARAMETERS --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE
```

### PowerShell

```powershell
# For Azure global regions

$inputObject = @{
  DeploymentName        = 'alz-SubscriptionPlacementDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ManagementGroupId     = 'alz'
  Location              = 'eastus'
  TemplateParameterFile = 'infra-as-code/bicep/modules/subscriptionPlacement/parameters/subscriptionPlacement.parameters.all.json'
  TemplateFile          = "infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.bicep"
}

New-AzManagementGroupDeployment @inputObject
```
OR
```powershell
# For Azure China regions

$inputObject = @{
  DeploymentName        = 'alz-SubscriptionPlacementDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ManagementGroupId     = 'alz'
  Location              = 'chinaeast2'
  TemplateParameterFile = 'infra-as-code/bicep/modules/subscriptionPlacement/parameters/subscriptionPlacement.parameters.all.json'
  TemplateFile          = "infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.bicep"
}
New-AzManagementGroupDeployment @inputObject
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
