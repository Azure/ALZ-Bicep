<!-- markdownlint-disable -->
## Known Issues
<!-- markdownlint-restore -->

This page lists the known issues and limitations currently present in ALZ-Bicep. Please review these before using the repository to understand any potential challenges or constraints.

## Issue 1: Deployment Failures with Azure PowerShell Version 13.0.0

- **Description:**
  When using the Accelerator or deploying locally with Azure PowerShell version 13.0.0 (the default version for both GitHub Actions and Azure DevOps in the Accelerator), the following error message may be encountered:
  `Error: Code=; Message=Received unexpected type Newtonsoft.Json.Linq.JObject`.

  Testing conducted by the ALZ Core team has confirmed that this issue directly impacts the deployment of the **ALZ Default Policy Assignments** module. However, there have also been reports of similar issues affecting the **ALZ Default Policy Definitions** module and the **ALZ Custom Role Definitions** module. This suggests that other modules may also experience the error, depending on specific parameters or customizations used during deployment.

- **Impact:**
  This issue affects Azure DevOps Agents, GitHub Actions workflows, and local deployments using Azure PowerShell version 13.0.0.
  The following deployments will fail:
  - ALZ Default Policy Assignments

  The following deployments may fail depending on specific parameters or customizations:
  - ALZ Default Policy Definitions
  - ALZ Custom Role Definitions

- **Workaround:**
  Until Azure DevOps Agents and GitHub-hosted runners are updated with a compatible version of Az modules, you can explicitly pin a specific Az version in the AzurePowerShell task. For example, remove the `azurePowerShellVersion: LatestVersion` and add `preferredAzurePowerShellVersion: 12.5.0` to your pipeline configuration.

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
  ```

  **GitHub Actions Workaround**

  **Before:**

  ```yaml
  runs:
  using: "composite"
  steps:
    - name: Run Bicep Deploy
      uses: azure/powershell@v2
      with:
        azPSVersion: 'latest'
  ```

  **After:**

  ```yaml
  runs:
  using: "composite"
  steps:
    - name: Run Bicep Deploy
      uses: azure/powershell@v2
      with:
        azPSVersion: '12.5.0'
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
