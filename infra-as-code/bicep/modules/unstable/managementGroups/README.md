# Module:  Management Groups

The Management Groups module deploys a management group hierarchy in a customer's tenant under the `Tenant Root Group`.  This is accomplished through a tenant-scoped Azure Resource Manager (ARM) deployment.

The default hierarchy can be modifed by assigning the  `parManagementGroupHierarchy` parameter in the parameters file. Each json object in the `parManagementGroupHierarchy` parameter value must have the following properties:
- `name`
- `displayName`
- `children`
  - Each child is another json object with the same properties as above.
  - If a management group has no children, then set the `children` property value to an empty array: `[]`
  - See the default value defined in `managementGroups.bicep` as an example.

The default hierarchy created by the deployment is:

- Tenant Root Group
  - Top Level Management Group (defined by parameter `parTopLevelManagementGroupDisplayName`)
    - Platform
      - Management
      - Connectivity
      - Identity
    - Landing Zones
      - Corp
      - Online
    - Sandbox
    - Decommissioned

## Parameters

The module requires the following inputs:

| Parameter                             | Type   | Description                                                                                                                                                     | Requirements                      | Example               |
| ------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- | --------------------- |
| parTopLevelManagementGroupPrefix      | string | Prefix for the management group hierarchy.  This management group will be created as part of the deployment.                                                    | 2-10 characters                   | `alz`                 |
| parTopLevelManagementGroupDisplayName | string | Display name for top level management group.  This name will be applied to the management group prefix defined in `parTopLevelManagementGroupPrefix` parameter. | Minimum two characters            | `Azure Landing Zones` |
| parTelemetryOptOut                    | bool   | Set Parameter to true to Opt-out of deployment telemetry                                                                                                        | Mandatory input, default: `false` | `false`               |
| parManagementGroupHierarchy | array | An array of json objects which can be used to overried the default management group structure. |

## Outputs

TBD

## Deployment

In this example, the management groups are created at the `Tenant Root Group` through a tenant-scoped deployment.

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# For Azure global regions
az deployment tenant create \
  --template-file infra-as-code/bicep/modules/managementGroups/managementGroups.bicep \
  --parameters @infra-as-code/bicep/modules/managementGroups/managementGroups.parameters.example.json \
  --location eastus
```
OR
```bash
# For Azure China regions
az deployment tenant create \
  --template-file infra-as-code/bicep/modules/managementGroups/managementGroups.bicep \
  --parameters @infra-as-code/bicep/modules/managementGroups/managementGroups.parameters.example.json \
  --location chinaeast2
```

### PowerShell

```powershell
# For Azure global regions
New-AzTenantDeployment `
  -TemplateFile infra-as-code/bicep/modules/managementGroups/managementGroups.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/managementGroups/managementGroups.parameters.example.json `
  -Location eastus
```
OR
```powershell
# For Azure China regions
New-AzTenantDeployment `
  -TemplateFile infra-as-code/bicep/modules/managementGroups/managementGroups.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/managementGroups/managementGroups.parameters.example.json `
  -Location chinaeast2  
```

![Example Deployment Output](../../managementGroups/media/exampleDeploymentOutput.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](../../managementGroups/media/bicepVisualizer.png "Bicep Visualizer")
