<!-- markdownlint-disable -->
## ALZ Bicep Accelerator
<!-- markdownlint-restore -->

> **Note:**
> This is an MVP release of the ALZ Bicep Accelerator. We are actively working on adding additional features and functionality to the Accelerator. Please check back often for updates.


This document provides prescriptive guidance around implementing, automating, and maintaining your ALZ Bicep module with the ALZ Bicep Accelerator.

### What is the ALZ Bicep Accelerator?

The ALZ Bicep Accelerator framework was developed to provide end-users with the following abilities:

- Allows for rapid onboarding and deployment of ALZ Bicep using full-fledged CI/CD pipelines with user provided input
  > **Note**
  > Currently we offer support for [GitHub Action Workflows](#getting-started-if-youre-using-github-actions) and [Azure DevOps Pipelines](#getting-started-if-youre-using-azure-devops-pipelines), but there are plans to add support for GitLab pipelines in the future
- Provides framework to not only stay in-sync with new [ALZ Bicep releases](https://github.com/Azure/ALZ-Bicep/releases), but also incorporates guidance around modifiying existing ALZ Bicep modules and/or associating custom modules to the framework
- Offers branching strategy guidance and pull request pipelines for linting the repository as well as validating any existing custom and/or modified Bicep modules
Accelerator Directory Tree:

![Accelerator Directory Tree](media/alz-bicep-accelerator-tree-output.png)

### Overview of Included ALZ Deployment Pipelines

We attempted to make the pipelines as flexible as possible while also reducing overall complexity. Essentially, the ALZ Bicep Accelerator is made up four distinct deployment pipelines that represent different phases of the ALZ Bicep deployment. Each workflow shares a common set of workflow configurations and deployment scripts including the following:

- Event based triggers (i.e. pushes to main and path filters for each workflow associated Bicep parameter file)
- PowerShell deployment scripts for each module that are referenced within [Azure PowerShell Action](https://github.com/marketplace/actions/azure-powershell-action) steps
  - The PowerShell scripts reference the modules and parameter files used within the [deployment flow documentation](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow#module-deployment-sequence). Therefore, we recommend you review the deployment flow documentation to understand the purpose of each module and the parameters that are used within the deployment scripts.
- Environment variables file (.env) which is used to store variables that are accessed within the PowerShell scripts
- What-If Deploment conditions which are triggered automatically if a pull request is created against the main branch. This allows for a user to validate the deployment and potential changes before merging the pull request into the main branch.
- Deployment conditions which are triggered automatically if a push is made to the main branch. This allows for a user to validate the deployment and potential changes before merging the pull request into the main branch.
  > **Note:**
  > Currently, the output of the GitHub Action workflows or the Azure DevOps Pipelines need to viewed within the respective portal. We are working on adding support for sending the output to the Pull Request comments section in the future.

The only thing that differs across the workflows is which ALZ Bicep modules are deployed as shown in the following table:

| Workflow/Pipeline Name            | Modules Deployed              |
|------------------------- |-------------------------------|
| ALZ-Bicep-1-Core | Management Groups Deployment, Logging and Sentinel Resource Group Deployment, Logging and Sentinel Deployment, Custom Policy Definitions Deployment, Custom Management Group Diagnostic Settings
| ALZ-Bicep-2-PolicyAssignments | Built-in and Custom Policy Assignments Deployment
| ALZ-Bicep-3-SubPlacement| Deploy Subscription Placement
| ALZ-Bicep-4A-HubSpoke| Connectivity Resource Group Deployment, Hub (Hub-and-Spoke) Deployment
| ALZ-Bicep-4B-VWAN | Connectivity Resource Group Deployment, Hub (VWAN) Deployment

### Getting Started if you're using GitHub Actions

In order to setup the Accelerator framework with the production GitHub Action Workflows, the following steps must be completed in the order listed:

1. Install the [ALZ PowerShell Module](https://github.com/Azure/ALZ-PowerShell-Module#installation) on your local development machine or within the Azure Cloud Shell using the following command:

    > **Warning:**
    > In order to use this module, [PowerShell 7.1 or higher](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3) needs to be installed

    ```powershell
    Install-Module -Name ALZ
    ```

1. Before you can utilize the module, ensure you have the prerequisites installed with the following command:

    ```powershell
    Test-ALZRequirement
    ```

    Currently this tests for:

    - [Supported minimum PowerShell version](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
    - [Azure PowerShell Module](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-10.1.0)
    - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
    - [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually)

1. Create your ALZ Bicep Accelerator framework with the following command:

    ```powershell
    New-ALZEnvironment -o <output_directory>
    ```

    > **Note:**
    > If the directory structure specified for the output location does not exist, the module will create the directory structure programatically.
1. Depending upon your preferred [network topology deployment](https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure#2-grant-access-to-user-andor-service-principal-at-root-scope--to-deploy-enterprise-scale-reference-implementation),  remove the associated workflow file for each deployment model
    - Traditional VNet Hub and Spoke = .github\workflows\alz-bicep-4a-hubspoke.yml
    - Virtual WAN = .github\workflows\alz-bicep-4b-vwan.yml

    > **Note:**
    > These workflow files and associated deployment scripts will be programatically removed in the future.

1. Review all parameter files within config/custom-parameters and update the values as needed for your desired ALZ configuration.

1. Follow this [GitHub documentation](https://docs.github.com/en/enterprise-cloud@latest/get-started/quickstart/create-a-repo#create-a-repository) to create a new remote GitHub repository that is NOT initialized

1. If you need to authenticate the GitHub remote repository from your local workstation or from the Azure Cloud Shell, please select an option below depending upon your preferences and requirements:
    - [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) - This will automatically prompt you to login when you attempt to push your commit in the following step
    - [GitHub Desktop](https://docs.github.com/en/desktop/installing-and-configuring-github-desktop/overview/getting-started-with-github-desktop)
    - [GitHub CLI](https://docs.github.com/en/github-cli/github-cli/quickstart)
    - [SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
    - [Personal Access Token with SAML](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-a-personal-access-token-for-use-with-saml-single-sign-on)

    Otherwise, proceed to the next step.

1. Run the following Git commands to get your remote branch in-sync with the local branch

    ```shell
    # Changes the current working directory to the newly created directory
    cd <output_directory>
    # Matches the remote URL with a name
    git remote add origin https://github.com/<OrganizationName>/<RepositoryName>.git
    # Ensures that your local branch name is set to main
    git branch -m main
    # Adds all changes in the working directory to the staging area
    git add .
    # Records a snapshot of your repository's staging area
    git commit -m "Initial commit"
    # Updates the remote branch with the local commit(s) if you did not initialize your remote repository.
    git push -u origin main
    ```

    >> **Note:**
    >> If you initialized your remote repository with a README.md file, you will need to run the following command to force the push to the remote repository
    >> ```git push -u origin main --force```

1. Now that the remote branch has the latest commit(s), you can configure your OpenID Connect (OIDC) identity provider with GitHub which will give the workflows access to your Azure environment.
    1. [Create an Azure Active Directory application/service principal](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-an-azure-active-directory-application-and-service-principal)
    1. [Add your federated credentials](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#add-federated-credentials-preview)
        1. Add one federated credential with the entity type set to 'Branch' and with a value for "Based on Selection" set to 'main'
        1. Add a secondary federated credential with the entity type set to 'Pull Request'
    1. [Create GitHub secrets](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-github-secrets)
        > **Note:**
        > The workflows reference secret names AZURE_TENANT_ID and AZURE_CLIENT_ID. If you choose to use different names, you will need to update the workflows accordingly.
    1. [Create RBAC Assignment for the application/service principal](https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure#2-grant-access-to-user-andor-service-principal-at-root-scope--to-deploy-enterprise-scale-reference-implementation)

1. All workflows are now ready to be deployed! For the initial deployment, manually trigger each workflow in the following order
    1. ALZ-Bicep-1-Core
    1. ALZ-Bicep-2-PolicyAssignments
    1. ALZ-Bicep-3-SubPlacement
    1. ALZ-Bicep-4A-HubSpoke or ALZ-Bicep-4B-VWAN

1. As part of the [branching strategy](#incoporating-a-branching-strategy), setup the branch protection rules against the main branch with the following selected as a starting point:

    - Require a pull request before merging
      - Require approvals
    - Require conversation resolution before merging
    - Do not allow bypassing the above settings

### Getting Started if you're using Azure DevOps Pipelines

In order to setup the Accelerator framework with the production ready Azure DevOps Pipelines, the following steps must be completed in the order listed:

1. Install the [ALZ PowerShell Module](https://github.com/Azure/ALZ-PowerShell-Module#installation) on your local development machine or within the Azure Cloud Shell using the following command:

    > **Warning:**
    > In order to use this module, [PowerShell 7.1 or higher](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3) needs to be installed

    ```powershell
    Install-Module -Name ALZ
    ```

1. Before you can utilize the module, ensure you have the prerequisites installed with the following command:

    ```powershell
    Test-ALZRequirement
    ```

    Currently this tests for:

    - [Supported minimum PowerShell version](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
    - [Azure PowerShell Module](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-10.1.0)
    - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
    - [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually)

1. Create your ALZ Bicep Accelerator framework with the following command:

    ```powershell
    New-ALZEnvironment -o <output_directory> -cicd "azuredevops"
    ```

    > **Note:**
    > If the directory structure specified for the output location does not exist, the module will create the directory structure programatically.
1. Depending upon your preferred [network topology deployment](https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure#2-grant-access-to-user-andor-service-principal-at-root-scope--to-deploy-enterprise-scale-reference-implementation),  remove the associated workflow file for each deployment model
    - Traditional VNet Hub and Spoke = .azuredevops\workflows\alz-bicep-4a-hubspoke.yml
    - Virtual WAN = .azuredevops\workflows\alz-bicep-4b-vwan.yml

    > **Note:**
    > These workflow files and associated deployment scripts will be programatically removed in the future.

1. Review all parameter files within config/custom-parameters and update the values as needed for your desired ALZ configuration.

1. Create an [Azure Active Directory application/service principal](https://learn.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal)

1. Create an [Azure Resource Manager Service Connection within Azure DevOps](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-with-an-existing-service-principal) at the Scope Level of Management Group. All pipeline files, except for the PR pipeline files reference a variable called SERVICE_CONNECTION_NAME. You will need to update the variable with the name of the service connection you created within this step.

1. Create an [RBAC Assignment for the application/service principal](https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure#2-grant-access-to-user-andor-service-principal-at-root-scope--to-deploy-enterprise-scale-reference-implementation)

1. Follow this [Azure DevOps documentation](https://learn.microsoft.com/en-us/azure/devops/repos/git/create-new-repo?view=azure-devops#create-a-repo-using-the-web-portal) to create a new remote Azure DevOps Git repository that is NOT initialized with a README.md file.

1. If you need to authenticate the Azure DevOps remote repository from your local workstation or from the Azure Cloud Shell, please select an option below depending upon your preferences and requirements:
    - [SSH](https://learn.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops)
    - [Git Credential Manager](https://learn.microsoft.com/en-us/azure/devops/repos/git/set-up-credential-managers?view=azure-devops)

    Otherwise, proceed to the next step.

1. Run the following Git commands to get your remote branch in-sync with the local branch

    ```shell
    # Changes the current working directory to the newly created directory
    cd <output_directory>
    # Matches the remote URL with a name
    git remote add origin https://github.com/<OrganizationName>/<RepositoryName>.git
    # Ensures that your local branch name is set to main
    git branch -m main
    # Adds all changes in the working directory to the staging area
    git add .
    # Records a snapshot of your repository's staging area
    git commit -m "Initial commit"
    # Updates the remote branch with the local commit(s) if you did not initialize your remote repository.
    git push -u origin main
    ```

    >> **Note:**
    >> If you initialized your remote repository with a README.md file, you will need to run the following command to force the push to the remote repository
    >> ```git push -u origin main --force```

1. Create your new pipelines within Azure DevOps. Ensure you select "Existing Azure Pipelines YAML file" when prompted  and select the pipeline files from the .azuredevops/pipelines

1. [Assign pipeline permissions to access the Service Connection you created previously](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#pipeline-permissions)    ```

1. All pipelines are now ready to be deployed! For the initial deployment, manually trigger each workflow in the following order
    1. ALZ-Bicep-1-Core
    1. ALZ-Bicep-2-PolicyAssignments
    1. ALZ-Bicep-3-SubPlacement
    1. ALZ-Bicep-4A-HubSpoke or ALZ-Bicep-4B-VWAN

1. As part of the [branching strategy](#incoporating-a-branching-strategy), setup the branch protection rules against the main branch with the following selected as a starting point:

    - Require a pull request before merging
      - Require approvals
    - Require conversation resolution before merging
    - Do not allow bypassing the above settings
    - Setup automated and required build valdiation reuquirements for all of the pipelines. This will ensure that all changes to the main branch are validated before merging as well as to provide a What-If analysis for the changes made to your ALZ environment. Finally, ensure you match the path filters for each build validation to what is specified in the pipeline files.
      > **Note:**
      > This last step is required if you are using GitHub and Bitbucket as your repository and integrating with Azure DevOps Pipelines.

### Incoporating a Branching Strategy

Branching strategies offer the ability to manage and organize changes to a codebase, reduce errors, improve collaboration, and support best practices such as testing, continuous integration and deployment, and release management.

For this framework, we recommend utilizing the [GitHub Flow branching strategy](https://docs.github.com/en/get-started/quickstart/github-flow) which is a lightweight, branch-based workflow.

![GitHub Flow Branching Strategy Diagram](media/alz-bicep-accelerator-branching-strategy-diagram.png)

As part of the framework, we include two PR workflows. The pipelines will perform the following tasks:

| Workflow Name           | Trigger   | Tasks               |
|-------------------------|-----------|---------------------|
| ALZ-Bicep-PR1-Build | Pull request against main branch and changes to any Bicep file or Bicep config file.             | Checks to see if there are any modified or custom modules residing within the config\custom-modules directory and if so, the workflow will lint the modules and ensure they can compile.
| ALZ-Bicep-PR2-Lint | Pull request against main branch. | Using [Super-Linter](https://github.com/github/super-linter), the workflow will lint everything in the codebase apart from the Bicep modules/files.

### Upgrading ALZ-Bicep Versions

The ALZ-Bicep repository regularly releases new [versions](https://github.com/Azure/ALZ-Bicep/releases). With each new release, the ALZ Bicep modules are updated to include new features and bug fixes. Therefore, we recommend that you upgrade to the latest version of ALZ Bicep as soon as possible.

With the ALZ Accelerator framework, we have designed the pipelines and directory structure to make it easy to upgrade to the latest ALZ Bicep version. The following steps will guide you through the upgrade process.

1. Prior to upgrading, read the release notes for the version you are upgrading to. The release notes will provide you with information on any breaking changes that may impact your deployment. This is especially important if you have created any custom modules or have [modified any of the ALZ Bicep modules](#incorporating-modified-alz-modules) that may have dependencies on the modules that are being upgraded.

1. Using the ALZ PowerShell Module, there is a cmdlet called `Get-ALZBicepRelease`. This will download a specified release version from the remote ALZ-Bicep repository and pull down to the local directory where your Accelerator framework was initially deployed.

    Here is an example of using the cmdlet to pull down version v0.16.3:

    ```powershell
    Get-ALZGithubRelease -githubRepoUrl "https://github.com/Azure/ALZ-Bicep" -releases "v0.16.3" -directoryForReleases "C:\Repos\ALZ\accelerator\upstream-releases\"
    ```

1. Once the ALZ Bicep release has been downloaded, you will need to update `upstream-releases-version` within the environment variables file (.env) with the version number of the release that you just downloaded. For example, if you downloaded v0.16.3, you would update the file with the following:

    ```text
    UPSTREAM_RELEASE_VERSION="v0.16.3"
    ```

1. You can now deploy the updated modules.

### Incorporating Modified ALZ Modules

We recommend that you do not modify the ALZ Bicep modules directly within the upstream-releases directory. Instead, we recommend that you copy the module file (e.g., logging.bicep, hubNetworking.bicep, etc.) that you would like to modify to the config\custom-modules directory. This will allow you to easily upgrade the ALZ Bicep version without having to worry about losing your customizations.

#### Example: Steps to follow for ALZ-Bicep Logging, Automation & Sentinel Module

1. Copy logging.bicep module file from upstream-releases directory to config\custom-modules directory

1. Modify the copied module file in custom-modules directory as needed. If new parameters are added to the module, you will need to update the relevant parameter file in the config\custom-parameters directory as well.

1. Update the config\custom-modules\logging.bicep file with the following comment at the top of the file:

    `// This module has been modified from the upstream-releases version <UpstreamReleaseVersion>`

1. Update the pipeline-scripts\Deploy-ALZLoggingAndSentinelResourceGroup.ps1 file and change the TemplateFile variable to point to the modified module file location as shown below:

    ```powershell
    [Parameter()]
    [String]$TemplateFile = "config\custom-modules\logging.bicep",
    ```

1. In order to trigger new deployments when subsequent changes are made, add the new module file path to the path-based filter workflow trigger in the ALZ-Bicep-1 workflow file as shown below:

    ```yaml
    on:
      push:
        paths:
          - "config/custom-modules/logging.bicep"
    ```

1. You are now ready to commit your changes to the main branch and trigger a new deployment.
