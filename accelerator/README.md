<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Accelerator
<!-- markdownlint-restore -->

This document provides prescriptive guidance around implementing, automating, and maintaining your ALZ Bicep framework with the ALZ Bicep Accelerator.

### What is the ALZ Bicep Accelerator?

The ALZ Bicep Accelerator feature was developed to provide end-users with the following abilities:

- Allows for rapid onboarding and deployment of ALZ Bicep using full-fledged CI/CD pipelines with user provided input
  > **Note**
  > Currently we only provide support for GitHub Action workflows, but there are plans to add support for Azure Pipelines and GitLab pipelines in the future.
- Provides framework to not only stay in-sync with new [ALZ Bicep releases](https://github.com/Azure/ALZ-Bicep/releases), but also incorporates guidance around editing existing ALZ Bicep modules or associating custom modules to the framework
- Offers branching strategy with pull request pipelines for linting repository as well as validating custom Bicep modules

### Getting Started

In order to setup the Accelerator framework with the production ready pipelines, the following steps must be completed in the order listed:

1. Install the [ALZ-PowerShell-Module](https://github.com/Azure/ALZ-PowerShell-Module#installation) on your local development machine or within the Azure Cloud Shell using the following command:

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

    - Supported minimum PowerShell version
    - Azure PowerShell Module
    - Git
    - Azure CLI
    - Bicep

1. Create your ALZ Bicep Accelerator framework with the following command:

    ```powershell
    New-ALZEnvironment -o <output_directory>
    ```

    > **Note:**
    > If the directory structure specified for the output location does not exist, the module will create the directory structure programatically.

1. Depending upon your preferred [network topology deployment](https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure#2-grant-access-to-user-andor-service-principal-at-root-scope--to-deploy-enterprise-scale-reference-implementation),  remove the assocaited workflow file for each deployment model
    - Traditional VNet Hub and Spoke = accelerator\.github\workflows\alz-bicep-4a.yml
    - Virtual WAN = accelerator\.github\workflows\alz-bicep-4b.yml

    > **Note:**
    > These workflow files and associated deployment scripts will be programatically removed in the future.

1. Follow this [GitHub documentation](https://docs.github.com/en/enterprise-cloud@latest/get-started/quickstart/create-a-repo#create-a-repository) to create a new remote Git repository

1. If you need to authenticate Git from your local workstation or from the Azure Cloud Shell, please following the steps provided [here](https://docs.github.com/en/get-started/quickstart/set-up-git#authenticating-with-github-from-git). Otherwise, proceed to the next step if Git had been authenticated to GitHub prior.

1. Run the following Git commands to get your local branch in sync with your remote branch

    ```shell
    # Matches the remote URL with a name
    git remote add origin https://github.com/<OrganizationName>/<RepositoryName>.git

    # Adds all changes in the working directory to the staging area.
    git add .

    # Records a snapshot of your repository's staging area.
    git commit -m "Initial commit"

    # Updates the remote branch with the local commit(s)
    git push -u origin main
    ```

1. Now that the remote branch has the latest commit(s), you can configure your OpenID Connect (OIDC) identity provider with GitHub which will give the workflows access to your Azure environment.
    1. [Create an Azure Active Directory application/service principal](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-an-azure-active-directory-application-and-service-principal)
    1. [Add your federated credentials](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#add-federated-credentials-preview)
    1. [Create GitHub secrets](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-github-secrets)
    1. [Create RBAC Assignment for the app registration/service](https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure#2-grant-access-to-user-andor-service-principal-at-root-scope--to-deploy-enterprise-scale-reference-implementation)

1. All workflows are now ready to be deployed! For the initial deployment, manually trigger each workflow in the following order
    1. ALZ-Bicep-1 Workflow
    1. ALZ-Bicep-2 Workflow
    1. ALZ-Bicep-3 Workflow
    1. ALZ-Bicep-4a Workflow or ALZ-Bicep-4b Workflow

   > **Note:**
   > The workflows utilize [triggers](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows), so ALZ deployment workflows deployments will occur as a result of a push against the main branch along with changes to file paths that are associated with the workflow.

1. As part of the [branching strategy documentation](#incoporating-a-branching-strategy), setup the branch protection rules against the main branch with the following selected as a starting point:

    - Require a pull request before merging
      - Require approvals
    - Require conversation resolution before merging
    - Do not allow bypassing the above settings

### Incoporating a Branching Strategy

Branching strategies offer the ability to manage and organize changes to a codebase, reduce errors, improve collaboration, and support best practices such as testing, continuous integration and deployment, and release management.

For this framework, we recommend utilizing the [GitHub Flow branching strategy](https://docs.github.com/en/get-started/quickstart/github-flow) which is a lightweight, branch-based workflow.

As part of the framework, we include two PR workflows. The pipelines will perform the following tasks:

| Workflow Name           | Trigger   | Tasks               |
|-------------------------|-----------|---------------------|
| ALZ-Bicep-PR-1 Workflow | Pull request against main branch and changes to any Bicep file or Bicep config file.             | Checks to see if there are any modified or custom modules residing within the config\custom-modules directory and if so, the workflow will lint the modules and ensure they can compile.
| ALZ-Bicep-PR-2 Workflow | Pull request against main branch. | Using [Super-Linter](https://github.com/github/super-linter), the workflow will lint everything in the codebase apart from the Bicep modules/files.

### Upgrading ALZ-Bicep Version

### Incorporating Modified or Custom Modules
