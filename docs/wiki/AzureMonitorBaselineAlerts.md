<!-- markdownlint-disable -->
## Azure Monitor Baseline Alerts
<!-- markdownlint-restore -->

Currently, [Azure Monitor Baseline Alerts (AMBA)](https://azure.github.io/azure-monitor-baseline-alerts/) is not integrated into the ALZ-Bicep repository. However, this is something we are working on and will be available in the near future.

If you would like to not wait for this integration, you can deploy AMBA as a standalone deployment. This may be the best option as well as the most familiar scenario if you originally deployed the ALZ-Bicep framework using the PowerShell or Azure CLI scripts provided within the module READMEs.
This can be done by following the guidance provided in the [AMBA documentation](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/deploy/Introduction-to-deploying-the-ALZ-Pattern/).

On the otherhand, if you would like to integrate the Azure Monitor Baseline Alerts into your existing [Accelerator](https://github.com/Azure/ALZ-Bicep/wiki/Accelerator) deployment, you can follow the guidance provided in the following sections.

> [!WARNING]
> The following guidance provides a simplified version of the integration and will differ to what will be offered in the final integration. This is to provide an immediate solution.

## Pre-Reqs

Please ensure you have deployed the initial Accelerator and meet the all pre-requisites as outlined in the the [AMBA prerequisites section](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/deploy/Introduction-to-deploying-the-ALZ-Pattern/#prerequisites) for ALZ.

## Integration Steps

1. The first integration step to perform is to clone AMBA to your local machine.

1. Navigate to `patterns\alz` in the cloned AMBA repository and copy the following directories and files:

- `policyAssignments`
- `policyDefinitions`
- `policySetDefinitions`
- `templates`
- `alzARM.json`

1. Paste the copied directories and files into a new directoy called `amba` within the `config\custom-modules` directory of your ALZ-Bicep Accelerator repository.

1. Navigate back to `patterns\alz` in the cloned AMBA repository and copy the `alzARM.param.json` file.

1. Paste the copied `alzARM.param.json` file into the `config\custom-parameters` directory of your ALZ-Bicep Accelerator repository.

1. Modify the `alzARM.param.json` file to incorporate your landing zone configuration. You can use the [AMBA Parameter Configuration](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/deploy/Deploy-with-Azure-PowerShell/#1-parameter-configuration) guidance as a reference point to understand how to configure the parameters.

1. Next, go into `pipeline-scripts` and create a new script called `Deploy-AMBA.ps1`, which will be used to deploy the AMBA resources and called within your GitHub Actions Workflow or Azure Pipeline.

1. Add the following code to the `Deploy-AMBA.ps1` script:

```powershell
param (
  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TopLevelMGPrefix = "$($env:TOP_LEVEL_MG_PREFIX)",

  [Parameter()]
  [String]$TemplateURI = "https://raw.githubusercontent.com/Azure/azure-monitor-baseline-alerts/main/patterns/alz/alzArm.json",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\alzArm.param.json",

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-AMBADeploy-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = $Location
  ManagementGroupId     = $TopLevelMGPrefix
  TemplateURI           = $TemplateURI
  TemplateParameterFile = $TemplateParameterFile
  WhatIf                = $WhatIfEnabled
  Verbose               = $true
}

New-AzManagementGroupDeployment @inputObject
```

1. Next, navigate to either `.azuredevOps\pipelines` or `.github\workflows` and open the `alz-bicep-1-core.yml` file. Depending upon which CI/CD platform you are using, you will need to modify the `alz-bicep-1-core.yml` file to include the following step after the Management Group deployment:

  GitHub Action to Add (alz-bicep-1-core.yml)

  ```yaml
  - name: "AMBA Deployment"
        uses: azure/powershell@v1
        with:
          inlineScript: |
            .\pipeline-scripts\Deploy-AMBA.ps1
          azPSVersion: "latest"
  ```

  Azure Pipeline Task to Add (alz-bicep-1-core.yml)

  ```yaml
  - task: AzurePowerShell@5
        displayName: "AMBA Deployment"
        inputs:
          azureSubscription: ${{ variables.SERVICE_CONNECTION_NAME }}
          azurePowerShellVersion: "LatestVersion"
          pwsh: true
          ScriptType: "InlineScript"
          Inline: |
            .\pipeline-scripts\Deploy-AMBA.ps1
  ```

1. Within the same files, modify the path based triggers to include the `config/custom-modules/amba/***` directory and the `config/custom-parameters/amba.parameters.all.json` file. This will ensure that any changes to the AMBA resources will trigger a new build.

> [!NOTE]
> For Azure Pipelines, if you are using Azure Repos as your repository, you will need to edit the branch policy of the `main` branch to include the path based filters.

1. Finally, commit the changes to your upstream repository, which will trigger a new build to deploy the AMBA resources.

> [!TIP]
> If you have any issues with the deployment, please open an issue an issue within [ALZ-Bicep](https://github.com/Azure/ALZ-Bicep/issues)
