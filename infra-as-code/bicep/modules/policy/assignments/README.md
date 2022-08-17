# Module: Policy Assignments

This module deploys Azure Policy Assignments to a specified Management Group and also assigns the relevant RBAC for the system-assigned Managed Identities created for policies that require them (e.g DeployIfNotExist & Modify effect policies).

> If you are looking for the default ALZ policy assignments check out [`./alzDefaults` directory](alzDefaults/README.md)

If you wish to add your own additional Azure Policy Assignments please review [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) and more specifically [Adding Custom Azure Policy Definitions](https://github.com/Azure/ALZ-Bicep/wiki/AddingPolicyDefs)

## Parameters

- [Parameter details for Management Group Policy Assignment](policyAssignmentManagementGroup.bicep.md)

## Outputs

The module does not generate any outputs.

## Deployment

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Deny Effect

In this example, the `Deny-PublicIP` custom policy definition will be deployed/assigned to the `alz-landingzones` management group.

#### Azure CLI - Deny

```bash
# For Azure global regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.deny.parameters.all.json \
  --location eastus \
  --management-group-id alz-landingzones
```
OR
```bash
# For Azure China regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.deny.parameters.all.json \
  --location chinaeast2 \
  --management-group-id alz-landingzones
```

#### PowerShell - Deny

```powershell
# For Azure global regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.deny.parameters.all.json `
  -Location eastus `
  -ManagementGroupId 'alz-landingzones'
```
OR
```powershell
# For Azure China regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.deny.parameters.all.json `
  -Location chinaeast2 `
  -ManagementGroupId 'alz-landingzones'
```

### DeployIfNotExists Effect

There are two different sets of input parameters files; one for deploying to Azure global regions, and another for deploying specifically to Azure China regions. This is due to a few Microsoft Defender for Cloud built-in policies which are not available in Azure China.

 | Azure Cloud    | Bicep template                        | Input parameters file                                           |
 | -------------- | ------------------------------------- | --------------------------------------------------------------- |
 | Global regions | policyAssignmentManagementGroup.bicep | parameters/policyAssignmentManagementGroup.dine.parameters.all.json    |
 | China regions  | policyAssignmentManagementGroup.bicep | parameters/mc-policyAssignmentManagementGroup.dine.parameters.all.json |


In this example, the `Deploy-MDFC-Config` custom policy definition will be deployed/assigned to the `alz-landingzones` management group (intermediate root management group). And the managed identity associated with the policy will also be assigned to the `alz-platform` management group, as defined in the parameter file: `parameters/policyAssignmentManagementGroup.dine.parameters.all.json` or `parameters/mc-policyAssignmentManagementGroup.dine.parameters.all.json`
#### Azure CLI - DINE

```bash
# For Azure global regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.dine.parameters.all.json \
  --location eastus \
  --management-group-id alz-landingzones
```
OR
```bash
# For Azure China regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/parameters/mc-policyAssignmentManagementGroup.dine.parameters.all.json \
  --location chinaeast2 \
  --management-group-id alz-landingzones
```

#### PowerShell - DINE

```powershell
# For Azure global regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.dine.parameters.all.json `
  -Location eastus `
  -ManagementGroupId 'alz-landingzones'
```
OR
```powershell
# For Azure China regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/parameters/mc-policyAssignmentManagementGroup.dine.parameters.all.json `
  -Location chinaeast2 `
  -ManagementGroupId 'alz-landingzones'
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
