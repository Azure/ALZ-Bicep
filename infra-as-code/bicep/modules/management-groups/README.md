# Module:  Management Groups

Management Groups module defines the management group structure that will be deployed in a customer's environment.  It will deploy:

  1. Platform management group with child management groups:
      * management
      * connectivity
      * identity
  2. Landing Zones management group with child management groups:
      * corp
      * online
  3. Sandbox management group
  4. Decommissioned management group


## Parameters

The module requires the following input parameters:

 Paramenter | Type | Description | Requirements | Example
----------- | ---- | ----------- | ------------ | -------
parTopLevelManagementGroupPrefix | string | Prefix for the management structure.  This management group will be created as part of the deployment. | Minimum two characters | `alz` |
parTopLevelManagementGroupDisplayName | string | Display name for top level management group prefix.  This name will be applied to the management group prefix defined in `parTopLevelManagementGroupPrefix` parameter. | Minimum two characters | `Azure Landing Zones` |

## Outputs

The moduel will generate the following outputs:

Otuput | Type | Example
------ | ---- | --------
outTopLevelMGId | string | /providers/Microsoft.Management/managementGroups/alz
outPlatformMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform
outPlatformManagementMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform-management
outPlatformConnectivityMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform-connectivity
outPlatformIdentityMGId | string | /providers/Microsoft.Management/managementGroups/alz-platform-identity
outLandingZonesMGId | string | /providers/Microsoft.Management/managementGroups/alz-landingzones
outLandingZonesCorpMGId | string | /providers/Microsoft.Management/managementGroups/alz-landingzones-corp
outLandingZonesOnlineMGId | string | /providers/Microsoft.Management/managementGroups/alz-landingzones-online
outSandboxesManagementGroupId | string | /providers/Microsoft.Management/managementGroups/alz-sandboxes
outDecommissionedManagementGroupId | string | /providers/Microsoft.Management/managementGroups/alz-decommissioned


## Deployment

**Example Deployment**

In this example, the management groups are created at the `Tenant Root Group` through a tenant-scoped deployment.

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
