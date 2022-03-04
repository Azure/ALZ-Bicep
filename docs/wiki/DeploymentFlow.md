<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Deployment Flow
<!-- markdownlint-restore -->

This document outlines the prerequisites, dependencies and flow to help orchestrate an end-to-end Azure Landing Zone deployment.  The orchestration templates provided with this reference implementation have been pre-configured to follow the dependencies described in this document.

## Prerequisites

1. Azure Active Directory Tenant.
2. Minimum 1 subscription.  Subscription(s) are required when configuring `Log Analytics Workspace` & `Hub Networking` services.  Each can be deployed in the same subscription or separate subscriptions based on deployment requirements.
3. Deployment Identity with `Owner` permission to the `/` root management group.  Owner permission is required to allow the Service Principal Account to create role-based access control assignments.  See [configuration instructions below](#deployment-identity).

## High Level Deployment Flow

![High Level Deployment Flow](media/high-level-deployment-flow.png)

## Module Deployment Sequence

Modules in this reference implementation must be deployed in the following order to ensure consistency across the environment:

| Order | Module                                 | Description                                                                                                                                                                                | Prerequisites                                                          | Module Documentation                                                                                                                                                  |
| :---: | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1   | Management Groups                      | Configures the management group hierarchy to support Azure Landing Zone reference implementation.                                                                                          | Owner role assignment at `/` root management group.                    | [infra-as-code/bicep/modules/managementGroups](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/managementGroups)                             |
|   2   | Custom Policy Definitions              | Configures Custom Policy Definitions at the `organization management group`.                                                                                                               | Management Groups.                                                     | [infra-as-code/bicep/modules/policy/definitions](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions)                         |
|   3   | Custom Role Definitions                | Configures custom roles based on Cloud Adoption Framework's recommendations at the `organization management group`.                                                                        | Management Groups.                                                     | [infra-as-code/bicep/modules/customRoleDefinitions](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/customRoleDefinitions)                   |
|   4   | Logging & Sentinel                     | Configures a centrally managed Log Analytics Workspace, Automation Account and Sentinel in the `Logging` subscription.                                                                     | Management Groups & Subscription for Log Analytics and Sentinel.       | [infra-as-code/bicep/modules/logging](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/logging)                                               |
|   5   | Role Assignments                       | Creates role assignments using built-in and custom role definitions.                                                                                                                       | Management Groups & Subscriptions.                                     | [infra-as-code/bicep/modules/roleAssignments](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/roleAssignments)                               |
|   6   | Subscription Placement                 | Moves one or more subscriptions to the target management group.                                                                                                                            | Management Groups & Subscriptions.                                     | [infra-as-code/bicep/modules/subscriptionPlacement](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/subscriptionPlacement)                   |
|   7   | Built-In and Custom Policy Assignments | Creates policy assignments to provide governance at scale.                                                                                                                                 | Management Groups, Log Analytics Workspace & Custom Policy Definitions | [infra-as-code/bicep/modules/policy/assignments/alzDefaults](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults) |

## Network Topology Deployment

The deployment flow above deploys an enterprise-ready platform foundation with all the necessary shared servicies. Next you need decide which network topology to implement that meets your requirements. The following lists examples of network topology deployment based on the recommended enterprise-scale architecture:

- [Enterprise-scale hub and spoke](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlowHS)
- [Enterprise-scale Virtual WAN](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlowVWAN)

## Deployment Identity

### Service Principal Account

A service principal account is required to automate through Azure DevOps or GitHub Workflows.

- **Service Principal Name**:  any name (i.e. `spn-azure-platform-ops`)
- **RBAC Assignment**
  - Scope:  `/` (Root Management Group)
  - Role Assignment:  `Owner`

> See [step-by-step instructions on Azure Docs](https://docs.microsoft.com/azure/azure-resource-manager/templates/deploy-to-tenant?tabs=azure-powershell#required-access) to configure the role assignment at `/` root management group.

### Configure Service Principal Account in Azure DevOps or GitHub

- Azure DevOps: [Setup Service Connection](https://docs.microsoft.com/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)

- GitHub: [Connect GitHub Actions to Azure](https://docs.microsoft.com/azure/developer/github/connect-from-azure)
