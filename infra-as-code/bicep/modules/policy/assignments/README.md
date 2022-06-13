# Module: Policy Assignments

This module deploys Azure Policy Assignments to a specified Management Group and also assigns the relevant RBAC for the system-assigned Managed Identities created for policies that require them (e.g DeployIfNotExist & Modify effect policies).

> If you are looking for the default ALZ policy assignments check out [`./alzDefaults` directory](alzDefaults/README.md)

If you wish to add your own additional Azure Policy Assignments please review [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) and more specifically [Adding Custom Azure Policy Definitions](https://github.com/Azure/ALZ-Bicep/wiki/AddingPolicyDefs)

## Parameters

> Please use the scroll horizontal scroll bar at the bottom of this table to scroll along to see the other columns!

The module requires the following inputs:

<!-- markdownlint-disable -->
 | Parameter                                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Requirement                                                                                                                                                                                                                                  | Example                                                                                                                                                                                                                                      | Default Value |
 | ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
 | parPolicyAssignmentName                                 | The name of the policy assignment.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Mandatory input. Can only be a maximum of 24 characters in length as per: [Naming rules and restrictions for Azure resources](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-name-rules#microsoftauthorization) | `Deny-Public-IP`                                                                                                                                                                                                                             | None          |
 | parPolicyAssignmentDisplayName                          | The display name of the policy assignment                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Mandatory input                                                                                                                                                                                                                              | `Deny the creation of Public IPs`                                                                                                                                                                                                            | None          |
 | parPolicyAssignmentDescription                          | The description of the policy assignment                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Mandatory input                                                                                                                                                                                                                              | `This policy denies creation of Public IPs under the assigned scope.`                                                                                                                                                                        | None          |
 | parPolicyAssignmentDefinitionId                         | The policy definition ID (full resource ID) for the policy to be assigned.                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Mandatory input                                                                                                                                                                                                                              | `/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91` (built-in) or `/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP` (custom) | None          |
 | parPolicyAssignmentParameters                           | An object containing the parameter values for the policy to be assigned.                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Mandatory input                                                                                                                                                                                                                              | `{"value":{"emailSecurityContact":{"value":"security_contact@replace_me"}}}`                                                                                                                                                                 | `{}`          |
 | parPolicyAssignmentParameterOverrides                   | An object containing parameter values that override those provided to parPolicyAssignmentParameters, usually via a JSON file and json(loadTextContent(FILE_PATH)). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between parPolicyAssignmentParameters & parPolicyAssignmentParameterOverrides, inputs provided to parPolicyAssignmentParameterOverrides will win. | Not mandatory                                                                                                                                                                                                                                | `{"value":{"emailSecurityContact":{"value":"different_contact@replace_me"}}}`                                                                                                                                                                | `{}`          |
 | parPolicyAssignmentNonComplianceMessages                | An array containing object/s for the non-compliance messages for the policy to be assigned. See [Non-compliance messages](https://docs.microsoft.com/azure/governance/policy/concepts/assignment-structure#non-compliance-messages) for more details on use.                                                                                                                                                                                                                                                                                 | Mandatory input                                                                                                                                                                                                                              | `[{"message":"Default message"}]`                                                                                                                                                                                                            | `[]`          |
 | parPolicyAssignmentNotScopes                            | An array containing a list of scope Resource IDs to be excluded for the policy assignment.                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Mandatory input                                                                                                                                                                                                                              | `["/providers/Microsoft.Management/managementgroups/alz","/providers/Microsoft.Management/managementgroups/alz-sandbox"]`                                                                                                                    | `[]`          |
 | parPolicyAssignmentEnforcementMode                      | The enforcement mode for the policy assignment. See [Enforcement Mode](https://aka.ms/EnforcementMode) for more details on use.                                                                                                                                                                                                                                                                                                                                                                                                              | Not mandatory. Will only allow values of `Default` or `DoNotEnforce`                                                                                                                                                                         | `Default`                                                                                                                                                                                                                                    | `Default`     |
 | parPolicyAssignmentIdentityType                         | The type of identity to be created and associated with the policy assignment. Only required for `Modify` and `DeployIfNotExists` policy effects                                                                                                                                                                                                                                                                                                                                                                                              | Not mandatory. Will only allow values of `None` or `SystemAssigned`                                                                                                                                                                          | `None`                                                                                                                                                                                                                                       |
 | parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs | An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally.                                                                                                                                                                                                                                                                                              | Not mandatory                                                                                                                                                                                                                                | `["alz","alz-sandbox"]`                                                                                                                                                                                                                      | `[]`          |
 | parPolicyAssignmentIdentityRoleAssignmentsSubs          | An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to.                                                                                                                                                                                                                                                                                                                     | Not mandatory                                                                                                                                                                                                                                | `["d4417fe6-3370-48e2-ab38-c7b926526fe7","fbec3ec1-292a-4207-831c-bd62fdb7b468"]`                                                                                                                                                            | `[]`          |
 | parPolicyAssignmentIdentityRoleDefinitionIds            | An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for `Modify` and `DeployIfNotExists` policy effects                                                                                                                                                                                                                                                                                                                   | Not mandatory. But required for a `Modify` and `DeployIfNotExists` policy effect assignment.                                                                                                                                                 | `alz`                                                                                                                                                                                                                                        | `[]`          |
 | parTelemetryOptOut                                      | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Mandatory input, default: `false`                                                                                                                                                                                                            | `false`                                                                                                                                                                                                                                      | `false`       |
<!-- markdownlint-restore -->

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
