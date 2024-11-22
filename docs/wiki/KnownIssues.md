<!-- markdownlint-disable -->
## Known Issues
<!-- markdownlint-restore -->

This page lists the known issues and limitations currently present in ALZ-Bicep. Please review these before using the repository to understand any potential challenges or constraints.

## Issue 1: Pipeline Deployment Failures with Azure PowerShell Version 13.0.0 on Azure DevOps Agents

- **Description:**
  When using the Accelerator, multiple users have reported deployment failures when utilizing Azure DevOps Agents with the latest Azure PowerShell version (13.0.0), configured as the default in the AzurePowerShell@5 task. The error message encountered is:
  `Error: Code=; Message=Received unexpected type Newtonsoft.Json.Linq.JObject`.

  This issue occurs during the deployment of the following modules:
  - Custom Policy Definitions
  - Custom Management Group Diagnostic Settings
  - ALZ Default Policy Assignments

  Preliminary reports suggest this issue may be specific to Azure DevOps Agents, though testing is underway to determine if it also impacts GitHub Actions workflows or other environments. Notably, deployments using version 13.0.0 of Azure PowerShell on local machines have been successful, indicating the issue might be limited to hosted agents.

- **Impact:**
  The following deployments fail:
  - Custom Policy Definitions
  - Custom Management Group Diagnostic Settings
  - ALZ Default Policy Assignments

- **Workaround:**
  Until the Azure DevOps Agents are updated with a compatible version of Az modules, you can explicitly pin a specific Az version for the AzurePowerShell task. For example removing the `azurePowerShellVersion: LatestVersion` and adding `preferredAzurePowerShellVersion: 12.5.0` to the AzurePowerShell task in your pipeline configuration.

  **Azure DevOps Workaround**

  **Before:**

  ```yaml
  - task: AzurePowerShell@5
    displayName: Check for First Deployment
    condition: eq(${{ parameters.whatIfEnabled }}, true)
    inputs:
      azureSubscription: ${{ parameters.serviceConnection }}
      pwsh: true
      azurePowerShellVersion: LatestVersion
      ScriptType: "InlineScript"
      Inline: |
        $managementGroupId = $env:MANAGEMENT_GROUP_ID
        $managementGroups = Get-AzManagementGroup
        $managementGroup = $managementGroups | Where-Object { $_.Name -eq $managementGroupId }

        $firstDeployment = $true

        if ($managementGroup -eq $null) {
          Write-Warning "Cannot find the $managementGroupId Management Group, assuming this is the first deployment. Some dependent resources may not exist yet."
        } else {
          Write-Host "Found the $managementGroupId Management Group, assuming this is not the first deployment."
          $firstDeployment = $false
        }

        Write-Host "##vso[task.setvariable variable=FIRST_DEPLOYMENT;]$firstDeployment"
  ```

  **After**

  ```yaml
  - task: AzurePowerShell@5
    displayName: Check for First Deployment
    condition: eq(${{ parameters.whatIfEnabled }}, true)
    inputs:
      azureSubscription: ${{ parameters.serviceConnection }}
      pwsh: true
      azurePowerShellVersion: OtherVersion
      preferredAzurePowerShellVersion: 12.5.0
      ScriptType: "InlineScript"
      Inline: |
        $managementGroupId = $env:MANAGEMENT_GROUP_ID
        $managementGroups = Get-AzManagementGroup
        $managementGroup = $managementGroups | Where-Object { $_.Name -eq $managementGroupId }

        $firstDeployment = $true

        if($managementGroup -eq $null) {
          Write-Warning "Cannot find the $managementGroupId Management Group, so assuming this is the first deployment. We must skip checking some deployments since their dependent resources do not exist yet."
        } else {
          Write-Host "Found the $managementGroupId Management Group, so assuming this is not the first deployment."
          $firstDeployment = $false
        }

        Write-Host "##vso[task.setvariable variable=FIRST_DEPLOYMENT;]$firstDeployment"
  ```

- **Status:** As we are not the team who owns Azure PowerShell or the Azure PowerShell Task, we are actively investigating the cause and will report the issue once confirmed to the applicable team(s). Updates will be provided as new information becomes available within the [original GitHub issue](https://github.com/Azure/ALZ-Bicep/issues/907). In the interim, pinning the Az version to 12.5.0 in your pipeline configurations is the recommended workaround if you encounter this issue.

## Issue 2: ALZ Default Policy Assignments Module Deployment Failure Due to Template Size

- **Description:** The ALZ Default Policy Assignments module may fail to deploy because the compiled ARM template from the Bicep module exceeds [Azure's 4 MB limit](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices#template-limits) due to the large number of policy assignments.
- **Impact:** Deployment may fail with an error indicating that the ARM template is too large.
- **Workaround:** Consider these approaches:
  - Deploy the module in smaller chunks.
  - Split the policy assignments into separate modules and deploy them individually.
  - If `parTelemetryOptOut` is set to `true`, comment out or remove the parameter and its associated resource declaration from the `.bicep` file.
- **Status:** We have reduced the ARM template size by condensing parameter descriptions . Refactoring the module will only be considered if necessary, particularly if additional policy assignments from a policy refresh impact deployments. We are also taking into consideration that we are currently working on transition to [Azure Verified Modules](https://github.com/Azure/ALZ-Bicep/issues/791), which will account for this issue in the long-term.

## How to Report an Issue

If you encounter an issue not listed here that would be helpful to be included or have additional information to provide, please open a [new issue](https://github.com/Azure/ALZ-Bicep/issues/new?assignees=&labels=bug&projects=&template=bug-report-issue-form.yaml&title=%5BPLACEHOLDER%5D+-+Place+a+descriptive+title+here) in the GitHub repository's issue tracker. Be sure to include detailed steps to reproduce the issue and any relevant context or screenshots.

We appreciate your help in improving ALZ-Bicep by reporting issues and providing feedback.
