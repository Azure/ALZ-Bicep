# Module:  Custom Role Definitions

This module defines custom roles based on the recommendations from the Azure Landing Zone Conceptual Architecture.  The role definitions are defined in [Identity and access management](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management) recommendations.

Module supports the following custom roles:

- [*ManagementGroupId] Subscription owner
- [*ManagementGroupId] Application owners (DevOps/AppOps)
- [*ManagementGroupId] Network management (NetOps)
- [*ManagementGroupId] Security operations (SecOps)

*The custom role names are prefixed with `[ManagementGroupId]` since custom roles scoped at Management Group level must be unique within the Microsoft Entra tenant. This will alleviate any conflicts if you chose to deploy a [canary environment](https://aka.ms/alz/canary).
For example, if the `ManagementGroupId` = **alz**, then each role will have this prefix **[alz]** like `[alz] Subscription owner`. See the [example output deployment](#example-deployment-output) below.

## Parameters

- [Parameters for Azure Commercial Cloud](generateddocs/customRoleDefinitions.bicep.md)
- [Parameters for Azure China Cloud](generateddocs/mc-customRoleDefinitions.bicep.md)

## Outputs

The module will generate the following outputs:

| Output                           | Type   | Example                                                                      |
| -------------------------------- | ------ | ---------------------------------------------------------------------------- |
| outRolesSubscriptionOwnerRoleId  | string | Microsoft.Authorization/roleDefinitions/8736d87d-8d31-53be-b952-a04c8d470f69 |
| outRolesApplicationOwnerRoleId   | string | Microsoft.Authorization/roleDefinitions/4308c4e6-07d5-534f-9e18-32769872a3f4 |
| outRolesNetworkManagementRoleId  | string | Microsoft.Authorization/roleDefinitions/4a200286-e2a0-5239-aa8f-fe0a90dd2eb5 |
| outRolesSecurityOperationsRoleId | string | Microsoft.Authorization/roleDefinitions/b2960c40-d3db-5190-94c1-5b07c9547956 |

## Deployment

There are two different sets of deployment; one for deploying to Azure global regions, and another for deploying specifically to Azure China regions. This is due to the following resource provider which is not returned in the list of providers from Azure Resource Manager in Azure China cloud.

> Microsoft.Support resource provider is not supported because Azure support in China regions is independently operated and provided by 21Vianet.

 | Azure Cloud    | Bicep template                 | Input parameters file                             |
 | -------------- | ------------------------------ | ------------------------------------------------- |
 | Global regions | customRoleDefinitions.bicep    | parameters/customRoleDefinitions.parameters.all.json |
 | China regions  | mc-customRoleDefinitions.bicep | parameters/customRoleDefinitions.parameters.all.json |

In this example, the custom roles will be deployed to the `alz` management group (the intermediate root management group).

Input parameter file `parameters/customRoleDefinitions.parameters.all.json` defines the assignable scope for the roles.  In this case, it will be the same management group (i.e. `alz`) as the one specified for the deployment operation. There is no change in the input parameter file for different Azure clouds because there is no change to the intermediate root management group.

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI

```bash
# For Azure global regions

# Management Group ID
MGID="alz"

# Chosen Azure Region
LOCATION="eastus"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-CustomRoleDefsDeployment-${dateYMD}"
TEMPLATEFILE="infra-as-code/bicep/modules/customRoleDefinitions/customRoleDefinitions.bicep"
PARAMETERS="@infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS
```
OR
```bash
# For Azure China regions

# Management Group ID
MGID="alz"

# Chosen Azure Region
LOCATION="chinaeast2"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-CustomRoleDefsDeployment-${dateYMD}"
TEMPLATEFILE="infra-as-code/bicep/modules/customRoleDefinitions/mc-customRoleDefinitions.bicep"
PARAMETERS="@infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json"

az deployment mg create --name ${NAME:0:63} --location $LOCATION --management-group-id $MGID --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell
# For Azure global regions

$inputObject = @{
  DeploymentName        = 'alz-CustomRoleDefsDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'eastus'
  ManagementGroupId     = 'alz'
  TemplateFile          = "infra-as-code/bicep/modules/customRoleDefinitions/customRoleDefinitions.bicep"
  TemplateParameterFile = 'infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject
```
OR
```powershell
# For Azure China regions

$inputObject = @{
  DeploymentName        = 'alz-CustomRoleDefsDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'chinaeast2'
  ManagementGroupId     = 'alz'
  TemplateFile          = "infra-as-code/bicep/modules/customRoleDefinitions/mc-customRoleDefinitions.bicep"
  TemplateParameterFile = 'infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject
```

#### Example Deployment Output

![Example Deployment Output](media/exampleDeploymentOutput.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
