# Module: ALZ Default Policy Assignments

This module deploys the default Azure Landing Zone Azure Policy Assignments to the Management Group Hierarchy and also assigns the relevant RBAC for the system-assigned Managed Identities created for policies that require them (e.g DeployIfNotExist & Modify effect policies).

If you wish to add your own additional Azure Policy Assignments please review [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) and more specifically [Adding Custom Azure Policy Definitions](https://github.com/Azure/ALZ-Bicep/wiki/AddingPolicyDefs)

## Parameters

- [Parameter details for ALZ Default Policy Assignments in Azure Commercial Cloud](alzDefaultPolicyAssignments.bicep.md)
- [Parameter details for ALZ Default Policy Assignments in Azure China Cloud](mc-alzDefaultPolicyAssignments.bicep.md)

## Outputs

The module does not generate any outputs.

## Deployment

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.
<!-- markdownlint-disable -->
> **Important:** If you decide to not use a DDoS Standard plan in your environment and therefore leave the parameter `parDdosProtectionPlanId` as an empty string (`''`) then the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues. For deployment in Azure China, leave the parameter `parDdosProtectionPlanId` as an empty string (`''`) because the DDoS Protection feature is not available in Azure China.
> 
> However, if you later do decide to deploy an DDoS Standard Plan, you will need to remember to come back and update the parameter `parDdosProtectionPlanId` with the resource ID of the DDoS Standard Plan to ensure the policy is applied to the relevant Management Groups. You can then use a policy [remediation task](https://docs.microsoft.com/azure/governance/policy/how-to/remediate-resources) to bring all non-compliant VNETs back into compliance, once a [compliance scan](https://docs.microsoft.com/azure/governance/policy/how-to/get-compliance-data#evaluation-triggers) has taken place.
<!-- markdownlint-restore -->

### Azure CLI
```bash
# For Azure global regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json \
  --location eastus \
  --management-group-id alz
```
OR
```bash
# For Azure China regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/alzDefaults/mc-alzDefaultPolicyAssignments.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json \
  --location chinaeast2 \
  --management-group-id alz
```

### PowerShell

```powershell
# For Azure global regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json `
  -Location eastus `
  -ManagementGroupId alz
```
OR
```powershell
# For Azure China regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/mc-alzDefaultPolicyAssignments.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json `
  -Location chinaeast2 `
  -ManagementGroupId alz
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")