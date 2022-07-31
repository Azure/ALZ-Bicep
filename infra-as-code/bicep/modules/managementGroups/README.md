# Module:  Management Groups

The Management Groups module deploys a management group hierarchy in a customer's tenant under the `Tenant Root Group`.  This is accomplished through a tenant-scoped Azure Resource Manager (ARM) deployment. The hierarchy can be modified by editing `managementGroups.bicep`.  The hierarchy created by the deployment is:

- Tenant Root Group
  - Top Level Management Group (defined by parameter `parTopLevelManagementGroupPrefix`)
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

| Parameter                             | Type   | Description                                                                                                                                                                          | Requirements                      | Example                                                                                 |
| ------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------- | --------------------------------------------------------------------------------------- |
| parTopLevelManagementGroupPrefix      | string | Prefix for the management group hierarchy.  This management group will be created as part of the deployment.                                                                         | 2-10 characters                   | `alz`                                                                                   |
| parTopLevelManagementGroupDisplayName | string | Display name for top level management group.  This name will be applied to the management group prefix defined in `parTopLevelManagementGroupPrefix` parameter.                      | Minimum two characters            | `Azure Landing Zones`                                                                   |
| parTopLevelManagementGroupParentId    | string | Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group. | Not required input, default `''`  | `/providers/Microsoft.Management/managementGroups/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| parLandingZoneMgAlzDefaultsEnable     | bool   | Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true.                                                                                       | Mandatory input, default: `true`  | `true`                                                                                  |
| parLandingZoneMgConfidentialEnable    | bool   | Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.                                                             | Mandatory input, default: `false` | `false`                                                                                 |
| parLandingZoneMgChildren              | object | Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed.                                                         | Not required input, default `{}`  | `{pci: {displayName: 'PCI'}}`                                                           |
| parTelemetryOptOut                    | bool   | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                             | Mandatory input, default: `false` | `false`                                                                                 |

### Child Landing Zone Management Groups Flexibility

This module allows some flexibility for deploying child Landing Zone Management Groups, e.g. Management Groups that live beneath the Landing Zones Management Group. This flexibility is controlled by three parameters which are detailed below. All of these parameters can be used together to tailor the child Landing Zone Management Groups.

- `parLandingZoneMgAlzDefaultsEnable`
  - Boolean - defaults to `true`
  - **Required**
  - Deploys following child Landing Zone Management groups if set to `true`:
    - `Corp`
    - `Online`
    - *These are the default ALZ Management Groups as per the conceptual architecture*
- `parLandingZoneMgConfidentialEnable`
  - Boolean - defaults to `false`
  - **Required**
  - Deploys following child Landing Zone Management groups if set to `true`:
    - `Confidential Corp`
    - `Confidential Online`
- `parLandingZoneMgChildren`
  - Object - default is an empty object `{}`
  - **Optional**
  - Deploys whatever you specify in the object as child Landing Zone Management groups.

These three parameters are then used to collate a single variable that is used to create the child Landing Zone Management Groups. Duplicates are removed if entered. This is done by using the `union()` function in bicep.

> Investigate the variable called `varLandingZoneMgChildrenUnioned` if you want to see how this works in the module.

#### `parLandingZoneMgChildren` Input Examples

Below are some examples of how to use this input parameter in both Bicep & JSON formats.

##### Bicep Example

```bicep
parLandingZoneMgChildren: {
  pci: {
    displayName: 'PCI'
  }
  'another-example': {
    displayName: 'Another Example'
  }
}
```

##### JSON Parameter File Input Example

```json
"parLandingZoneMgChildren": {
    "value": {
        "pci": {
          "displayName": "PCI"
        },
        "another-example": {
          "displayName": "Another Example"
        }
    }
}
```

## Outputs

The module will generate the following outputs:

| Output                                     | Type   | Example                                                                                                                                              |
| ------------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| outTopLevelManagementGroupId               | string | /providers/Microsoft.Management/managementGroups/alz                                                                                                 |
| outPlatformManagementGroupId               | string | /providers/Microsoft.Management/managementGroups/alz-platform                                                                                        |
| outPlatformManagementManagementGroupId     | string | /providers/Microsoft.Management/managementGroups/alz-platform-management                                                                             |
| outPlatformConnectivityManagementGroupId   | string | /providers/Microsoft.Management/managementGroups/alz-platform-connectivity                                                                           |
| outPlatformIdentityManagementGroupId       | string | /providers/Microsoft.Management/managementGroups/alz-platform-identity                                                                               |
| outLandingZonesManagementGroupId           | string | /providers/Microsoft.Management/managementGroups/alz-landingzones                                                                                    |
| outLandingZoneChildrenManagementGroupIds   | array  | `[/providers/Microsoft.Management/managementGroups/alz-landingzones-corp, /providers/Microsoft.Management/managementGroups/alz-landingzones-online]` |
| outSandboxManagementGroupId                | string | /providers/Microsoft.Management/managementGroups/alz-sandbox                                                                                         |
| outDecommissionedManagementGroupId         | string | /providers/Microsoft.Management/managementGroups/alz-decommissioned                                                                                  |
| outTopLevelManagementGroupName             | string | alz                                                                                                                                                  |
| outPlatformManagementGroupName             | string | alz-platform                                                                                                                                         |
| outPlatformManagementManagementGroupName   | string | alz-platform-management                                                                                                                              |
| outPlatformConnectivityManagementGroupName | string | alz-platform-connectivity                                                                                                                            |
| outPlatformIdentityManagementGroupName     | string | alz-platform-identity                                                                                                                                |
| outLandingZonesManagementGroupName         | string | alz-landingzones                                                                                                                                     |
| outLandingZoneChildrenManagementGroupNames | array  | `[Corp, Online]`                                                                                                                                     |
| outSandboxManagementGroupName              | string | alz-sandbox                                                                                                                                          |
| outDecommissionedManagementGroupName       | string | alz-decommissioned                                                                                                                                   |

## Deployment

In this example, the management groups are created at the `Tenant Root Group` through a tenant-scoped deployment.

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# For Azure global regions
az deployment tenant create \
  --template-file infra-as-code/bicep/modules/managementGroups/managementGroups.bicep \
  --parameters @infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.all.json \
  --location eastus
```
OR
```bash
# For Azure China regions
az deployment tenant create \
  --template-file infra-as-code/bicep/modules/managementGroups/managementGroups.bicep \
  --parameters @infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.all.json \
  --location chinaeast2
```

### PowerShell

```powershell
# For Azure global regions
New-AzTenantDeployment `
  -TemplateFile infra-as-code/bicep/modules/managementGroups/managementGroups.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.all.json `
  -Location eastus
```
OR
```powershell
# For Azure China regions
New-AzTenantDeployment `
  -TemplateFile infra-as-code/bicep/modules/managementGroups/managementGroups.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.all.json `
  -Location chinaeast2  
```

![Example Deployment Output](media/exampleDeploymentOutput.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
