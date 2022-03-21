<!-- markdownlint-disable -->
## How to Consume `ALZ-Bicep`
<!-- markdownlint-restore -->

## Background

> This guidance supports the [Deployment Flow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) guidance, it is not a replacement

The `ALZ-Bicep` repository (this repository) has been created to help customers and partners to deploy and deliver the [Azure Landing Zones (ALZ) conceptual architecture](https://aka.ms/alz#azure-landing-zone-conceptual-architecture) into an Azure AD Tenant utilizing [Bicep](https://aka.ms/bicep) as the Infrastructure-as-Code (IaC) tooling and language.

The style in which the Bicep modules have been authored in this repo are aimed at consumers of all skill levels. This is in an effort to make the modules as accessible as possible; especially for those that are newer to the world of IaC and/or Bicep.

We authored the modules with this in mind to help consumers accelerate their journey to Azure, as ALZ is likely to be one of the key first pieces of Azure a customer or partner will deploy and configure to establish the platform guardrails, connectivity and security elements to enable the future success of workloads within Azure.

> More on the style of the modules can be seen in the [Contribution Guide](https://github.com/Azure/ALZ-Bicep/wiki/Contributing)

## Ways to Consume `ALZ-Bicep`

There are various ways to consume the Bicep modules included in `ALZ-Bicep`. The options are:

- Clone this repository
- Fork & Clone this repository
- Download a `.zip` copy of this repo
- Upload a copy of the locally cloned/downloaded modules to your own:
  - Git Repository
  - Private Bicep Module Registry
    - See:
      - [Azure Landing Zones - Private/Organizational Azure Container Registry Deployment (also known as private registry for Bicep modules)](https://github.com/Azure/ALZ-Bicep/wiki/ACRDeployment)
      - [Create private registry for Bicep modules](https://docs.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry)
  - Template Specs
    - See:
      - [Azure Resource Manager template specs in Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/template-specs)
- Use and reference the modules directly from the Microsoft Public Bicep Registry - ***Coming Soon (awaiting feature release in Bicep)***

The option to use will be different per consumer based on their experience and skill levels with the various pieces of technology and their features.

> Consumers can also use the above listed methods together with CI/CD pipelines to deploy the modules. See [Azure Landing Zones Bicep - Pipelines](https://github.com/Azure/ALZ-Bicep/wiki/PipelinesOverview) for more information and guidance

## Customizing the `ALZ-Bicep` Modules

Whatever way you may choose to consume the modules we do expect, and want, customers and partners to customize the modules to suit their needs and requirements for their design in their local copies of the modules.

For example, if you want to change the names of the Management Groups, outside of what the parameters allow you to change and customize, then by opening up the `managementGroups.bicep` module you should be able to read, understand and customize the required lines to meet your requirements easily; due to the way the modules have been authored as shared above.

This customized module can then be deployed into your environment to deliver the desired changes and architecture.

<!-- markdownlint-disable -->
> **IMPORTANT:** If you believe the changes you have made should be more easily available to be customized by a parameter etc. in the module, then please raise an [issue](https://github.com/Azure/ALZ-Bicep/issues) for a 'Feature Request' on the repository 👍
> 
> If you wish to, also feel free to submit a pull request relating to the issue which we can review and work with you to potentially implement the suggestion/feature request 👍
<!-- markdownlint-restore -->

## Considerations when Customizing the `ALZ-Bicep` Module

Whilst customizing the modules on the whole is straightforward and simple, there are some key things to consider depending on which modules you customize.

> See a topic or something missing from this section? Please raise an [issue](https://github.com/Azure/ALZ-Bicep/issues) on the repo and let us know and feel free to contribute a pull request also 👍

### Management Groups

Whilst most of the modules rely upon the Intermediate Root Management Group (e.g. `alz` or `contoso`) some of the modules, like [`alzDefaultPolicyAssignments`](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) rely upon other Management Groups existing like `corp` to make policy assignments at this scope.

So if you customize the Management Group hierarchy you must also change references in other modules, as shown above. These are generally held in `variables` within each module to make it easier to customize in a single location per module, rather than multiple places per module.

> This is mainly in the [`alzDefaultPolicyAssignments`](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) module, but this module is designed to be prescriptive in its delivery of the ALZ conceptual architecture
