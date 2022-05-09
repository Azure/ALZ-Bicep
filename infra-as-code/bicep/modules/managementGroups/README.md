# Module:  Management Groups

The Management Groups module deploys a management group hierarchy in a customer's tenant under the `Tenant Root Group`.  This is accomplished through a tenant-scoped Azure Resource Manager (ARM) deployment.  The heirarchy can be modifed by editing `managementGroups.bicep`.  The hierarchy created by the deployment is:

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

| Parameter                             | Type   | Description                                                                                                                                                     | Requirements                      | Example               |
| ------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- | --------------------- |
| parTopLevelManagementGroupPrefix      | string | Prefix for the management group hierarchy.  This management group will be created as part of the deployment.                                                    | 2-10 characters                   | `alz`                 |
| parTopLevelManagementGroupDisplayName | string | Display name for top level management group.  This name will be applied to the management group prefix defined in `parTopLevelManagementGroupPrefix` parameter. | Minimum two characters            | `Azure Landing Zones` |
| parTelemetryOptOut                    | bool   | Set Parameter to true to Opt-out of deployment telemetry                                                                                                        | Mandatory input, default: `false` | `false`               |

## Outputs

The module will generate the following outputs:

| Output                                     | Type   | Example                                                                    |
| ------------------------------------------ | ------ | -------------------------------------------------------------------------- |
| outTopLevelManagementGroupId               | string | /providers/Microsoft.Management/managementGroups/alz                       |
| outPlatformManagementGroupId               | string | /providers/Microsoft.Management/managementGroups/alz-platform              |
| outPlatformManagementManagementGroupId     | string | /providers/Microsoft.Management/managementGroups/alz-platform-management   |
| outPlatformConnectivityManagementGroupId   | string | /providers/Microsoft.Management/managementGroups/alz-platform-connectivity |
| outPlatformIdentityManagementGroupId       | string | /providers/Microsoft.Management/managementGroups/alz-platform-identity     |
| outLandingZonesManagementGroupId           | string | /providers/Microsoft.Management/managementGroups/alz-landingzones          |
| outLandingZonesCorpManagementGroupId       | string | /providers/Microsoft.Management/managementGroups/alz-landingzones-corp     |
| outLandingZonesOnlineManagementGroupId     | string | /providers/Microsoft.Management/managementGroups/alz-landingzones-online   |
| outSandboxManagementGroupId                | string | /providers/Microsoft.Management/managementGroups/alz-sandbox               |
| outDecommissionedManagementGroupId         | string | /providers/Microsoft.Management/managementGroups/alz-decommissioned        |
| outTopLevelManagementGroupName             | string | alz                                                                        |
| outPlatformManagementGroupName             | string | alz-platform                                                               |
| outPlatformManagementManagementGroupName   | string | alz-platform-management                                                    |
| outPlatformConnectivityManagementGroupName | string | alz-platform-connectivity                                                  |
| outPlatformIdentityManagementGroupName     | string | alz-platform-identity                                                      |
| outLandingZonesManagementGroupName         | string | alz-landingzones                                                           |
| outLandingZonesCorpManagementGroupName     | string | alz-landingzones-corp                                                      |
| outLandingZonesOnlineManagementGroupName   | string | alz-landingzones-online                                                    |
| outSandboxManagementGroupName              | string | alz-sandbox                                                                |
| outDecommissionedManagementGroupName       | string | alz-decommissioned                                                         |

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
