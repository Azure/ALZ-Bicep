# Module: Resource Group

This module creates a Resource group to be utilized by other modules.  

Module deploys the following resources:

- Resource Group

## Parameters

The module requires the following inputs:

 | Parameter                | Type   | Default | Description                                              | Requirement                                  | Example |
 | ------------------------ | ------ | ------- | -------------------------------------------------------- | -------------------------------------------- | ------- |
 | parLocation | string | None    | Location where Resource Group will be deployed           | Valid Azure Region                           | eastus2 |
 | parResourceGroupName     | string | None    | Name of Resource Group to create in the specified region | 2-64 char, letters, numbers, and underscores | Hub     |
 | parTags                      | object | Empty object `{}`          | Array of Tags to be applied to Resource Group   | None        | `{"key": "value"}`                                                                                                                                    |
 | parTelemetryOptOut       | bool   | `false` | Set Parameter to true to Opt-out of deployment telemetry | none                                         | `false` |

## Outputs

The module will generate the following outputs:

| Output | Type | Example |
| ------ | ---- | ------- |
| outResourceGroupName | string | `Hub` |
| outResourceGroupId | string | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/Hub` |

## Deployment

Module is intended to be called from other modules as a reusable resource.

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")