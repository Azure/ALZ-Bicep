<!-- markdownlint-disable -->
## Adding Custom Azure Policy Definitions
<!-- markdownlint-restore -->

## Overview

The [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions) in `ALZ-Bicep` deploys all of the custom Azure Policy Definitions and Initiatives (also know as Definition Sets) that are part of Azure Landing Zones (Enterprise-Scale) as described in more detail in the wiki article [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive)

However, it is expected that most customers will want or need to add their own custom Azure Policy Definitions and Initiatives and deploy them to their Intermediate Root Management Group (e.g. `Contoso`) to then assign them at scopes beneath this Management Group to help them meet their requirements.

This is where this wiki article will help explain how this is possible and advise of the various ways this can also be done.

## What are the options?

There are a few options for you to deploy your own custom Azure Policy Definitions and Initiatives using Bicep and more specifically `ALZ-Bicep`.

1. Extend the [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions) from `ALZ-Bicep`
   - Adding a definition as a `.json` file to the `lib` and updating the variable of `varCustomPolicyDefinitionsArray` or `varCustomPolicySetDefinitionsArray`
     - Can use `Invoke-PolicyToBicep.ps1` script as explained in [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) to generate variables
2. Define the definition via "native" Bicep and deploy as a separate deployment
   - Using API schema for [Policy Definitions](https://docs.microsoft.com/azure/templates/microsoft.authorization/policydefinitions?tabs=bicep) or [Policy Initiatives (Sets)](https://docs.microsoft.com/azure/templates/microsoft.authorization/policysetdefinitions?tabs=bicep)
   - Example can be seen [here](https://github.com/Azure/azure-quickstart-templates/blob/master/managementgroup-deployments/mg-policy/main.bicep)

We recommend were possible to use option 1 and extend the current `ALZ-Bicep` approach for deploying custom policies as this keeps the deployment process simplified as it's a single deployment to manage for all custom policies.

## How do I extend the `ALZ-Bicep` Custom Policy Definitions module?

> ✋ Where possible avoid using `-`'s (hyphens/dashes) as these are an unsupported character in Bicep. camelCase or use `_` instead 👍

To extend the [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions) from `ALZ-Bicep` follow the below process.

1. Navigate to the relevant `lib` directory
   - Policy Definition = `infra-as-code\bicep\modules\policy\definitions\lib\policy_definitions`
   - Policy Initiative (Set) = `infra-as-code\bicep\modules\policy\definitions\lib\policy_set_definitions`
2. Copy/clone an existing `.json` file and rename it to something appropriate
   - Try to copy a policy with the same effect as the policy you are wanting to add
   - **Important:** The file name of the `.json` file is not important. It can be anything you like as long as it ends `.json`
3. Amend contents of new file to values for the new policy definition/initiative
   - Common properties to change: `name`, `mode`, `displayName`, `description`, `metadata`, `parameters`, `policyRule`, `then`, `effect`
4. Run the [`Invoke-PolicyToBicep.ps1`](https://github.com/Azure/ALZ-Bicep/blob/main/.github/scripts/Invoke-PolicyToBicep.ps1) script to update the `_policyDefinitionsBicepInput.txt` and/or `_policySetDefinitionsBicepInput.txt` files in the `lib` folders
   1. Copy the entire contents of the relevant `.txt` file and replace the contents of the associated variable in the [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions)
      - Policy Definition = `_policyDefinitionsBicepInput.txt` placed into variable named `varCustomPolicyDefinitionsArray` (place copied contents inside of array `[]`)
      - Policy Initiative (Set) & Parameter Variables = Copy the entire contents of `_policySetDefinitionsBicepInput.txt` and replace variable named `varCustomPolicySetDefinitionsArray` and parameter variables below it with copied contents
5. Redeploy the updated [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions) via your configured method (locally via Azure CLI or PowerShell or via Azure DevOps pipeline or GitHub action)
6. New Policy Definitions now deployed to intermediate root Management Group (e.g. `Contoso`)

> For step 4 you could also manually copy and add the object for your new Policy Definitions into the array variables of `varCustomPolicyDefinitionsArray` or `varCustomPolicySetDefinitionsArray` following the defined schema already inside the array of objects.

## Handling a large amount of additional custom Policy Definitions

As Bicep is ultimately just compiling ARM templates behind the scenes, deployments of Bicep files/modules are still subject to the same limits as ARM Templates. The main limit to be aware of here is the `4 MB` total size limit for a single ARM Template.

Today the [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions) from `ALZ-Bicep` results in a `874 KB` ARM Template file `JSON` file being created.

This has plenty of room for expansion but it is worth keeping in mind as you may hit the `4 MB` limit and see the errors of `JobSizeExceededException` or `DeploymentJobSizeExceededException`.

### The fix

To get around this, split the policy definitions into 2 or more Bicep files.

For example, you could leave the [Custom Policy Definitions module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions) from `ALZ-Bicep` as is and then copy/clone this module and add your own custom Policy Definitions and Initiatives into this separate module.

> Ensure you deploy all of your Custom Policy Definitions at the correct stage of your deployment as per the guidance in the [Deployment Flow wiki article](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow).

## Support

If you have any issues or require any assistance or advice please raise a [GitHub Issue](https://github.com/Azure/ALZ-Bicep/issues/new/choose) on the repo and we will work with you to assist where possible.
