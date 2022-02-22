<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Pipelines
<!-- markdownlint-restore -->

This document provides high-level guidance for deploying the ALZ modules with pipelines and provides sample code for GitHub Actions and Azure DevOps Pipelines. The sample code leverages the orchestration templates, deployment sequence, and prerequisites described in the [DeploymentFlow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) document.

## Prerequisites

1. Azure Active Directory Tenant.
2. Minimum 1 subscription.  Subscription(s) are required when configuring `Log Analytics Workspace` & `Hub Networking` services.  Each can be deployed in the same subscription or separate subscriptions based on deployment requirements.
3. Deployment Identity with `Owner` permission to the `/` root management group.  Owner permission is required to allow the Service Principal Account to create role-based access control assignments.  See [configuration instructions](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow#deployment-identity).
4. GitHub or Azure DevOps account.

## ALZ Orchestration

### Overview

A pipeline is the repeatable process defined in a configuration file that you use to test and deploy your code. A pipeline includes all the steps you want to execute and in what order. You define your pipeline in a YAML file. A YAML file is a structured text file, similar to how Bicep is a structured text file. You can create and edit YAML files by using any text editor. Because a pipeline YAML file is a code file, the file is stored with your Bicep code in your Git repository. You use Git features to collaborate on your pipeline definition. You can manage different versions of your pipeline file by using commits and branches.

### Sample Pipelines

The sample pipelines sequentially deploy the nine modules detailed in the [DeploymentFlow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) document in a single pipeline. The pipelines have been configured with manual triggers for learning and experimentation.

### Sample Pipeline Code

- [GitHub Actions](https://github.com/Azure/ALZ-Bicep/blob/wiki-pipelines/docs/wiki/PipelinesGitHub.md)
- [Azure DevOps Pipelines](https://github.com/Azure/ALZ-Bicep/blob/wiki-pipelines/docs/wiki/PipelinesADO.md)

### Sample Pipeline Flowchart

```mermaid
flowchart TD
    A[Deploy Management Groups] --> B[Deploy Custom Policy Definitions];
    B --> C[Deploy Custom Role Definitions];
    C --> D[Deploy Logging Resource Group];
    D --> E[Deploy Logging];
    E --> F[Deploy Hub Networking Resource Group];
    F --> G[Deploy Hub Network];
    G --> H[Deploy Role Assignment];
    H --> I[Deploy Subscription Placement];
    I --> J[Deploy Default Policy Assignments];
    J --> K[Deploy Spoke Networking Resource Group];
    K --> L[Deploy Spoke Network];
```

### Considerations

The sample code provides a simple example of a deployment pipeline. In production environments it will likely be necessary to use more advanced pipelines to meet additional requirements. Often different teams are responsible for the various ALZ components and may need to manage their deployments separately to meet their particular requirements. 

The sample code uses manually triggered pipelines for learning purposes. For GitHub Actions we use `on: [workflow_dispatch]` event for a manually triggered workflow. For Azure DevOps we use `trigger: none` for a manually triggered pipeline run. Typically teams will want to take a more automated approach to running workflows based upon events that occur in the repository, such as a pull request to the main branch. For an example of an automated workflow, please review the [bicep-build-to-validate.yml](https://github.com/Azure/ALZ-Bicep/blob/main/.github/workflows/bicep-build-to-validate.yml) file in the workflows directory of this repo.

For many scenarios, it may also make sense to take a more modular approach to ALZ deployment. While a single pipeline is good for learning purposes, separate workflows aligned to ALZ components and the teams that manage them will likely be required for many organizations.

## Recommended Learning

### GitHub Actions

- [Deploy Azure resources by using Bicep and GitHub Actions](https://docs.microsoft.com/en-us/learn/paths/bicep-github-actions/)
- [How to automatically trigger GitHub Actions workflows](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow)

### Azure DevOps Pipelines

- [Deploy Azure resources by using Bicep and Azure Pipelines](https://docs.microsoft.com/en-us/learn/paths/bicep-azure-pipelines/)
- [Azure DevOps Pipelines triggers](https://docs.microsoft.com/en-us/azure/devops/pipelines/build/triggers?view=azure-devops)