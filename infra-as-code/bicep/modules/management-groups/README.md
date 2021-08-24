# Module:  Management Groups

The Management Groups module deploys a management group hierarchy in a customer's tenant under the `Tenant Root Group`.  This is accomplished through a tenant-scoped Azure Resource Manager (ARM) deployment.  The heirarchy can be modifed by editing `mgmtGroups.bicep`.  The hierarchy created by the deployment is:

  * Tenant Root Group
    * Top Level Management Group (defined by parameter `parTopLevelManagementGroupPrefix`)
      * Platform
          * Management
          * Connectivity
          * Identity
      * Landing Zones
          * Corp
          * Online
      * Sandbox
      * Decommissioned


## Parameters

The module requires the following inputs:

 Paramenter | Type | Description | Requirements | Example
----------- | ---- | ----------- | ------------ | -------
parTopLevelManagementGroupPrefix | string | Prefix for the management group hierarchy.  This management group will be created as part of the deployment. | 2-10 characters | `alz` |
parTopLevelManagementGroupDisplayName | string | Display name for top level management group.  This name will be applied to the management group prefix defined in `parTopLevelManagementGroupPrefix` parameter. | Minimum two characters | `Azure Landing Zones` |

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------
outTopLevelMGId | string | /providers/Microsoft.Management/managementGroups/alz
outPlatformMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform
outPlatformManagementMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform-management
outPlatformConnectivityMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform-connectivity
outPlatformIdentityMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform-identity
outLandingZonesMGId | string | /providers/Microsoft.Management/managementGroups/alz-landingzones
outLandingZonesCorpMGId | string | /providers/Microsoft.Management/managementGroups/alz-landingzones-corp
outLandingZonesOnlineMGId | string | /providers/Microsoft.Management/managementGroups/alz-landingzones-online
outSandboxManagementGroupId | string | /providers/Microsoft.Management/managementGroups/alz-sandbox
outDecommissionedManagementGroupId | string | /providers/Microsoft.Management/managementGroups/alz-decommissioned


## Deployment

In this example, the management groups are created at the `Tenant Root Group` through a tenant-scoped deployment.

> For the below examples we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
az deployment tenant create \
  --template-file infra-as-code/bicep/modules/management-groups/mgmtGroups.bicep \
  --parameters @infra-as-code/bicep/modules/management-groups/mgmtGroups.parameters.example.json \
  --location eastus
```

### PowerShell

```powershell
New-AzTenantDeployment `
  -TemplateFile infra-as-code/bicep/modules/management-groups/mgmtGroups.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/management-groups/mgmtGroups.parameters.example.json `
  -Location eastus
```

![Example Deployment Output](media/example-deployment-output.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicep-visualizer.png "Bicep Visualizer")
