<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Accelerator
<!-- markdownlint-restore -->

This document provides prescriptive guidance around implementing, automating, and maintaining your ALZ Bicep framework with the ALZ Bicep Accelerator.

### What is the ALZ Bicep Accelerator?

The ALZ Bicep Accelerator feature was developed to provide end-users with the following abilities:

- Allows for rapid onboarding and deployment of ALZ Bicep using full-fledged CI/CD pipelines with user provided input
  > **Note**
  > This is a note Currently we only provide support for GitHub Action workflows, but there are plans to add support for Azure Pipelines and GitLab pipelines in the future.
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
