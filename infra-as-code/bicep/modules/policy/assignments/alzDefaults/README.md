# Module: ALZ Default Policy Assignments

This module deploys the default Azure Landing Zone Azure Policy Assignments to the Management Group Hierarchy and also assigns the relevant RBAC for the system-assigned Managed Identities created for policies that require them (e.g DeployIfNotExist & Modify effect policies).

## Parameters

> Please use the scroll horizontal scroll bar at the bottom of this table to scroll along to see the other columns!

The module requires the following inputs:

 | Parameter                                            | Description                                                                        | Requirement | Example                                                                                                                                               | Default Value                     |
 | ---------------------------------------------------- | ---------------------------------------------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
 | parTopLevelManagementGroupPrefix                     | Prefix for the management group hierarchy.                                         | Yes         | `alz`                                                                                                                                                 | `alz`                             |
 | parLogAnalyticsWorkSpaceAndAutomationAccountLocation | The region where the Log Analytics Workspace & Automation Account are deployed.    | Yes         | `eastus`                                                                                                                                              | `eastus`                          |
 | parLogAnalyticsWorkspaceResourceID                   | Log Analytics Workspace Resource ID                                                | Yes         | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics` | None                              |
 | parLogAnalyticsWorkspaceLogRetentionInDays           | Number of days of log retention for Log Analytics Workspace                        | Yes         | `365`                                                                                                                                                 | `365`                             |
 | parAutomationAccountName                             | Automation Account name                                                            | Yes         | `alz-automation-account`                                                                                                                              | `alz-automation-account`          |
 | parMSDFCEmailSecurityContact                         | An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to. | Yes         | `security_contact@replace_me.com`                                                                                                                     | `security_contact@replace_me.com` |
 | parDdosProtectionPlanId                              | ID of the DDoS Protection Plan which will be applied to the Virtual Networks       | Yes         | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/Hub_Networking_POC/providers/Microsoft.Network/ddosProtectionPlans/alz-Ddos-Plan` | (empty string)                    |
 | parTelemetryOptOut                                   | Set Parameter to true to Opt-out of deployment telemetry                           | Yes         | `false`                                                                                                                                               | `false`                           |

## Outputs

The module does not generate any outputs.

## Deployment

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# For Azure global regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.parameters.example.json \
  --location eastus \
  --management-group-id alz
```
OR
```bash
# For Azure China regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep \
  --parameters @infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.parameters.example.json \
  --location chinaeast2 \
  --management-group-id alz
```

### PowerShell

```powershell
# For Azure global regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.parameters.example.json `
  -Location eastus `
  -ManagementGroupId alz
```
OR
```powershell
# For Azure China regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.parameters.example.json `
  -Location chinaeast2 `
  -ManagementGroupId alz
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")