# Azure Landing Zones Bicep - Deployment Flow

This document outlines the prerequisites, dependencies and flow to help orchestrate an end-to-end Azure Landing Zone deployment.

## Prerequisites

1. Azure Active Directory Tenant.
2. Minimum 2 subscriptions: `Logging` and `Connectivity`.
3. [Service Principal Account](#service-principal-account) with `Owner` permission to the `Root Tenant Group`.  Owner permission is required to allow the Service Principal Account to create role-based access control assignments.

## High Level Deployment Flow

![High Level Deployment Flow](media/high-level-deployment-flow.png)


## Module Deployment Sequence

Modules in this reference implementation must be deployed in the following order to ensure consistency across the environment:

| Order | Module                                 | Description                                                                                                            | Module Documentation |
| :---: | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | -------------------- |
| 1     | Management Groups                         | Configures the management group hierarchy to support Azure Landing Zone reference implementation.                      | [infra-as-code/bicep/modules/management-groups/README.md](../../infra-as-code/bicep/modules/management-groups/README.md) |
| 2     | Custom Role Definitions                   | Configures custom roles based on Cloud Adoption Framework's recommendations at the `organization management group`.    | [infra-as-code/bicep/modules/custom-role-definitions/README.md](../../infra-as-code/bicep/modules/custom-role-definitions/README.md)
| 3     | Custom Policy Definitions                 | Configures Custom Policy Definitions at the `organization management group`.                                           | [infra-as-code/bicep/modules/policy/definitions/README.md](../../infra-as-code/bicep/modules/policy/definitions/README.md)
| 4     | Logging & Sentinel                        | Configures a centrally managed Log Analytics Workspace, Automation Account and Sentinel in the `Logging` subscription. | [infra-as-code/bicep/modules/logging/README.md](../../infra-as-code/bicep/modules/logging/README.md) |
| 5     | Built-In and Custom Policy Assignments    | Creates policy assignments to provide governance at scale.                                                             | TBD |
| 6     | Role Assignments    | Creates role assignments using built-in and custom role definitions.                                                                         | [infra-as-code/bicep/modules/reusable/role-assignments/README.md](../../infra-as-code/bicep/modules/reusable/role-assignments/README.md) |
| 7     | Subscription Placement                    | Moves one or more subscriptions to the target management group.                                                        | [infra-as-code/bicep/modules/reusable/subscription-placement/subscription-placement.bicep](.././infra-as-code/bicep/modules/reusable/subscription-placement/subscription-placement.bicep)
| 8     | Hub Networking                            | Creates Hub networking infrastructure with Azure Firewall to support Hub & Spoke network topology in the `Connectivity` subscription. | [infra-as-code/bicep/modules/hub-networking/README.md](../../infra-as-code/bicep/modules/hub-networking/README.md)
| 9     | Corp Connected Spoke Network              | Creates Spoke networking infrastructure with Virtual Network Peering to support Hub & Spoke network topology.  Spoke subscriptions are used for deploying construction sets and workloads. | [infra-as-code/bicep/modules/spoke-networking/README.md](../../infra-as-code/bicep/modules/spoke-networking/README.md) |

## Service Principal Account

A service principal account is required to automate through Azure DevOps or GitHub Workflows. 

* **Service Principal Name**:  any name (i.e. spn-azure-platform-ops)

* **RBAC Assignment**

    * Scope:  Tenant Root Group (this is a management group)

    * Role Assignment:  `Owner`

You may follow the [step-by-step instructions on Azure/Enterprise-Scale](https://github.com/Azure/Enterprise-Scale/blob/main/docs/EnterpriseScale-Setup-aad-permissions.md) to configure the role assignment.

  
**Configure Service Principal Account in Azure DevOps or GitHub:**

* Azure DevOps: [Setup Service Connection](https://docs.microsoft.com/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)

* GitHub: [Connect GitHub Actions to Azure](https://docs.microsoft.com/azure/developer/github/connect-from-azure)
