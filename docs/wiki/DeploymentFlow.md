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

| Order | Module                                    | Description                                                                                                                                                                                 | Prerequisites                                                          | Module Documentation |
| :---: | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------  | -------------------- |
| 1     | Management Groups                         | Configures the management group hierarchy to support Azure Landing Zone reference implementation.                                                                                           | Owner role assignment at `/` root management group.                    | [infra-as-code/bicep/modules/managementGroups](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/managementGroups)
| 2     | Custom Role Definitions                   | Configures custom roles based on Cloud Adoption Framework's recommendations at the `organization management group`.                                                                         | Management Groups.                                                     | [infra-as-code/bicep/modules/customRoleDefinitions](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/customRoleDefinitions)
| 3     | Custom Policy Definitions                 | Configures Custom Policy Definitions at the `organization management group`.                                                                                                                | Management Groups.                                                     | [infra-as-code/bicep/modules/policy/definitions](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions)
| 4     | Logging & Sentinel                        | Configures a centrally managed Log Analytics Workspace, Automation Account and Sentinel in the `Logging` subscription.                                                                      | Management Groups & Subscription for Log Analytics and Sentinel.       | [infra-as-code/bicep/modules/logging](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/logging)
| 5     | Built-In and Custom Policy Assignments    | Creates policy assignments to provide governance at scale.                                                                                                                                  | Management Groups, Log Analytics Workspace & Custom Policy Definitions | [infra-as-code/bicep/modules/policy/assignments](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments)
| 6     | Role Assignments                          | Creates role assignments using built-in and custom role definitions.                                                                                                                        | Management Groups & Subscriptions.                                     | [infra-as-code/bicep/modules/roleAssignments](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/roleAssignments) |
| 7     | Subscription Placement                    | Moves one or more subscriptions to the target management group.                                                                                                                             | Management Groups & Subscriptions.                                     | [infra-as-code/bicep/modules/subscriptionPlacement](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/subscriptionPlacement)
| 8     | Hub Networking                            | Creates Hub networking infrastructure with Azure Firewall to support Hub & Spoke network topology in the `Connectivity` subscription.                                                       | Management Groups, Subscription for Hub Networking.                    | [infra-as-code/bicep/modules/hubNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/hubNetworking)
| 9     | Corp Connected Spoke Network              | Creates Spoke networking infrastructure with Virtual Network Peering to support Hub & Spoke network topology.  Spoke subscriptions are used for deploying construction sets and workloads.  | Management Groups, Hub Networking & Subscription for spoke networking  | [infra-as-code/bicep/modules/spokeNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/spokeNetworking) |

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
