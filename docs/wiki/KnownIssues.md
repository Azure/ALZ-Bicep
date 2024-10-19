<!-- markdownlint-disable -->
## Known Issues
<!-- markdownlint-restore -->

This page lists the known issues and limitations currently present in ALZ-Bicep. Please review these before using the repository to understand any potential challenges or constraints.

## Issue 1: What-If Check Fails within Azure DevOps Pipeline/GitHub Actions Workflow with the error: `Additional content found in JSON reference object. A JSON reference object should only have a $ref property. Path 'parResourceLockConfig.defaultValue'`

- **Description:** There is a bug with the Azure PowerShell Module version 11.3.1 where the default JSON serializer used to read Bicep output treats `$ref` properties as a JSON reference, whereas the desired behavior is to preserve it in the serialized JSON. We do specify within our workflows/pipelines to use the latest version of Az module within each relevant task/action. However, the "latest" version correlates to the latest version installed on the particular agent/runner, which is 11.3.1 at this time.
- **Impact:** All What-If checks/operations fail within Azure DevOps Pipeline/GitHub Actions Workflows
- **Workaround:** To mitigate this issue until the agents have the updated Az version installed, you can explicitly reference a particular Az version for each PowerShell task/action. For example:
  Azure DevOps Workaround:

  ```yaml
  - task: AzurePowerShell@5
        displayName: "Logging and Sentinel Resource Group Deployment"
        inputs:
          azureSubscription: ${{ variables.SERVICE_CONNECTION_NAME }}
          azurePowerShellVersion: OtherVersion
          preferredAzurePowerShellVersion: 11.5.0
          pwsh: true
          ScriptType: "InlineScript"
          Inline: |
            .\pipeline-scripts\Deploy-ALZLoggingAndSentinelResourceGroup.ps1
  ```

  GitHub Actions Workaround:

  ```yaml
  - name: "Logging and Sentinel Resource Group Deployment"
        uses: azure/powershell@v1
        with:
          inlineScript: |
            .\pipeline-scripts\Deploy-ALZLoggingAndSentinelResourceGroup.ps1
          azPSVersion: "11.5.0"
  ```

- **Status:** As our team doesn't directly own the impacted module or have control over the agents/runners, we aim to enhance flexibility to assist with such issues in the future. To achieve this, we plan to introduce a variable in the .env file, enabling version control without the need for individual additions.

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
