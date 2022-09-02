<!-- markdownlint-disable -->
## Assigning Azure Policies
<!-- markdownlint-restore -->

## Overview

`ALZ-Bicep` provides a flexible [Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments) that not only handles the Policy Assignment itself to a Management Group but also the Managed Identity and required RBAC Role Assignment to the same scope as the Policy Assignment as well as providing options to make RBAC Role Assignments to additional scopes, if required.

`ALZ-Bicep` also provides the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) that makes all of the recommended/default Policy Assignments as per the [Azure Landing Zone Accelerator](https://aka.ms/caf/ready/accelerator). This is effectively an orchestration Bicep file that calls and uses the [Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments) multiple times to make the Policy Assignments at the desired scopes.

It is expected that most customers will want or need to make additional Azure Policy Assignments of either built-in or custom Policy Definitions to help them meet their requirements. This is where this wiki article will help explain how this is possible and advise of the various ways this can also be done.

## What are the options?

There are a few options for you to make additional Policy Assignments using Bicep and more specifically `ALZ-Bicep`.

1. Extend the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) from `ALZ-Bicep`
   - *(optional)* Adding additional assignments as a `.json` file to the `lib` and add additional variables like `varPolicyAssignmentDenyIPForwarding` etc.
     - Can use `Invoke-PolicyToBicep.ps1` script as explained in [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) to generate variables for assignments once assignment `.json` file in the `lib`.
2. Create your own additional Policy Assignments orchestration module, cloning the approach used in the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) from `ALZ-Bicep`
   - Calling and using the [Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments) `N` number of times
   - *(optional)* Deploy after [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) from `ALZ-Bicep` in your flow
3. Define the assignment via "native" Bicep and deploy as a separate deployment
   - Using API schema for [Policy Assignments](https://docs.microsoft.com/azure/templates/microsoft.authorization/policyassignments?tabs=bicep)
   - Example can be seen [here](https://github.com/Azure/azure-quickstart-templates/blob/master/managementgroup-deployments/mg-policy/main.bicep)
   - Need to ensure you make the required RBAC Role Assignments also as a separate resource declaration for policies that use Managed Identities for remediation tasks like `DeployIfNotExists` and `Modify`
     - Using API schema for [RBAC Role Assignments](https://docs.microsoft.com/azure/templates/microsoft.authorization/roleassignments?tabs=bicep)

> For options 1 & 2 the use of `.json` files in the lib is completely optional, you can also call the [Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments) and pass in the parameter values in a "hardcoded" fashion. You can even mix these approaches and pass in some parameter values from the `.json` files in the `lib` and others via "hardcoded" values. <br><br>
> When mixing policy assignment parameter values from `.json` files in the `lib` and also "hardcoded" values ensure you use the module parameter of [`parPolicyAssignmentParameterOverrides`](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments#parameters) to ensure your "hardcoded" values take precedence over those values from the `.json` files in the `lib` referenced via the associated variables for each policy assignment.

We recommend were possible to use option 1 or 2 and extend the current `ALZ-Bicep` approach for assigning additional policies. Option 1 is more suited to those customers that only need to add a handful of additional policies to the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults). Where as option 2 is better suited for those customers that want assign a significant amount of additional policies or want to maintain the separation between the ALZ default policy assignments and their own additional assignments.

> Option 2 will make it easier to pull in updates from `ALZ-Bicep` for the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) if there are any changes to the defaults and will reduce chances of merge conflicts and manual remediation to merge them.

## How do I extend the `ALZ-Bicep` ALZ Default Policy Assignments module?

To extend the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) from `ALZ-Bicep` follow the below process.

> ⚠️ Before assigning a policy its definition must already exist, please review the [Deployment Flow wiki article](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) for orchestration guidance and [How Does ALZ-Bicep Implement Azure Policies?](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) for policy specific guidance ⚠️ <br><br>
> If you do not wish to use a `.json` file in the `lib` for the assignment then please start at step 5 of the below process 👍

1. Navigate to the Policy Assignments `lib` directory: `infra-as-code\bicep\modules\policy\assignments\lib\policy_assignments`
2. Copy/clone an existing `.json` file and rename it to something appropriate
   - Try to copy a policy with the same effect as the policy you are wanting to add
   - **Important:** The file name of the `.json` file is not important. It can be anything you like as long as it ends `.json`
3. Amend contents of new file to values for the new policy assignment
   - Common properties to change: `name`, `displayName`, `description`, `metadata`, `parameters`, `policyDefinitionId`, `enforcementMode`, `identity`
4. Run the [`Invoke-PolicyToBicep.ps1`](https://github.com/Azure/ALZ-Bicep/blob/main/.github/scripts/Invoke-PolicyToBicep.ps1) script to update the `_policyAssignmentsBicepInput.txt` file in the `lib` folder
   1. Copy the entire contents of the relevant `_policyAssignmentsBicepInput.txt` file and replace the variables for the policy assignments metadata ([lines 78 to 202 today in the `alzDefaultPolicyAssignments.bicep` module](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep#L78-L202))
5. Define a new module declaration using the [Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments) in the [`alzDefaultPolicyAssignments.bicep` module](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep)
   - You could also copy an existing [`alzDefaultPolicyAssignments.bicep` module](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep) policy assignment module declaration that uses the same effect as you require in your new assignment
     - [`DeployIfNotExists` effect example - `Deploy-MDFC-Config` policy assignment - `modPolicyAssignmentIntRootDeployMDFCConfig` (lines 242 to 269)](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep#L242-L269)
       - *Note the use of `parPolicyAssignmentParameterOverrides`*
     - [`Deny` effect example - `Deny-Subnet-Without-Nsg` policy assignment - `modPolicyAssignmentIdentDenySubnetWithoutNSG` (lines 445 to 458)](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep#L445-L458)
   - Change the parameter input values to the desired values to assign your new policy
     - Refer to the [Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments) documentation for parameter information
     - These can be "hardcoded" **or** from the associated `.json` file in the `lib`, referenced via a variable generated in step 4, that you have created in the previous steps
6. Redeploy the updated [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) via your configured method (locally via Azure CLI or PowerShell or via Azure DevOps pipeline or GitHub action)
7. New Policy Assignments now deployed to specified scopes with associated Managed Identities and RBAC Role Assignments, if required.

## What about if I want to follow option 2?

The steps explained in the above section to extend the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) still apply and should be followed however you will do this in a separate Bicep file instead.

You will also need to ensure you create unique deployment names for each policy assignment as we do in the [ALZ Default Policy Assignments module](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) in the variable named `varModuleDeploymentNames` which is referenced for each policy assignment to its associated deployment name.

## Support

If you have any issues or require any assistance or advice please raise a [GitHub Issue](https://github.com/Azure/ALZ-Bicep/issues/new/choose) on the repo and we will work with you to assist where possible.
