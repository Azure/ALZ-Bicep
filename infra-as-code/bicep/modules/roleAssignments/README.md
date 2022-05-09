# Module:  Role Assignments for Management Groups & Subscriptions

This module provides role assignment capabilities across Management Group & Subscription scopes. Role assignments are part of [Identity and Access Management (IAM)](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management), which is one of the critical design areas in Enterprise-Scale Architecture. The role assignments can be performed for:

- Managed Identities (System and User Assigned)
- Service Principals
- Security Groups

This module contains 4 Bicep templates, you may optionally choose one of these modules to deploy depending on which scope you want to assign roles from broad to narrow; management group to subscription:

| Template                                | Description                                                                                                                               | Deployment Scope |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| roleAssignmentManagementGroup.bicep     | Performs role assignment on one management group                                                                                          | Management Group |
| roleAssignmentManagementGroupMany.bicep | Performs role assignment on one or more management groups.  This template uses `roleAssignmentManagementGroup.bicep` for the deployments. | Management Group |
| roleAssignmentSubscription.bicep        | Performs role assignment on one subscription                                                                                              | Subscription     |
| roleAssignmentSubscriptionMany.bicep    | Performs role assignment on one or more subscriptions.  This template uses `roleAssignmentSubscription.bicep` for the deployments.        | Management Group |

## Parameters

The module requires the following required input parameters.

All templates require an input for `parAssigneeObjectId` and this value is dependent on the Service Principal type.  Azure CLI and PowerShell commands can be executed to identify the correct `object id`.  Examples:

### Azure CLI - Find Object ID

```bash
# Identify Object Id for User Assigned / System Assigned Managed Identity
# Example: az identity show --resource-group rgManagedIdentities --name alz-managed-identity  --query 'principalId'
az identity show --resource-group <RESOURCE_GROUP> --name <IDENTITY_NAME> --query 'principalId'

# Identify Object Id for Service Principal (App Registration)
# Require read permission to query Azure Active Directory
# Example:  az ad sp show --id c705dc53-7c95-42bc-b1d5-75e172571370 --query objectId
az ad sp show --id <APP_REGISTRATION_APPLICATION_ID> --query objectId

# Identify Object Id for Security Group
# Require read permission to query Azure Active Directory
# Example: az ad group show --group SG_ALZ_SECURITY --query objectId
az ad group show --group <SECURITY_GROUP_NAME> --query objectId
```

### PowerShell - Find Object ID

```powershell
# Identify Object Id for User Assigned / System Assigned Managed Identity
# Example: (Get-AzADServicePrincipal -DisplayName 'alz-managed-identity').Id
(Get-AzADServicePrincipal -DisplayName '<IDENTITY_NAME>').Id

# Identify Object Id for Service Principal (App Registration)
# Require read permission to query Azure Active Directory
# Example:  (Get-AzADServicePrincipal -DisplayName 'Azure Landing Zone SPN').Id
(Get-AzADServicePrincipal -DisplayName '<APP_REGISTRATION_DISPLAY_NAME>').Id

# Identify Object Id for Security Group
# Require read permission to query Azure Active Directory
# Example: Get-AzureADGroup -SearchString 'SG_ALZ_SECURITY'
Connect-AzureAD
(Get-AzureADGroup -SearchString '<SECURITY_GROUP_NAME>').ObjectId
```

### roleAssignmentManagementGroup.bicep

| Parameter                 | Type   | Description                                                                                                                                                               | Requirement                      | Example                                |
| ------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- | -------------------------------------- |
| parRoleAssignmentNameGuid | string | A GUID representing the role assignment name.  Default:  guid(managmentGroup().name, parRoleDefinitionId, parAssigneeObjectId)                                                                   | Unique GUID                      | `f3b171da-2023-4508-b467-042a53f4cd5d` |
| parRoleDefinitionId       | string | Role Definition ID(i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)                                                                           | Must exist                       | `acdd72a7-3385-48ef-bd42-f606fba81ae7` |
| parAssigneePrincipalType  | string | Principal type of the assignee. Allowed values are `Group` (Security Group) or `ServicePrincipal` (Service Principal or System/User Assigned Managed Identity)            | One of [Group, ServicePrincipal] | `ServicePrincipal`                     |
| parAssigneeObjectId       | string | Object ID of groups, service principals or  managed identities. For managed identities use the principal ID. For service principals, use the object id and not the app ID | Must exist                       | `a86fe549-7f87-4873-8b0e-82f0081a0034` |
| parTelemetryOptOut        | bool   | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                  | none                             | `false`                                |

### roleAssignmentManagementGroupMany.bicep

| Parameter                | Type            | Description                                                                                                                                                              | Requirement                      | Example                                                  |
| ------------------------ | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- | -------------------------------------------------------- |
| parManagementGroupIds    | Array of string | A list of management group scopes that will be used for role assignment (i.e. [alz-platform-connectivity, alz-platform-identity]).  Default = []                         | Must exist                       | `['alz-platform-connectivity', 'alz-platform-identity']` |
| parRoleDefinitionId      | string          | Role Definition ID(i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)                                                                          | Must exist                       | `acdd72a7-3385-48ef-bd42-f606fba81ae7`                   |
| parAssigneePrincipalType | string          | Principal type of the assignee. Allowed values are `Group` (Security Group) or `ServicePrincipal` (Service Principal or System/User Assigned Managed Identity)           | One of [Group, ServicePrincipal] | `ServicePrincipal`                                       |
| parAssigneeObjectId      | string          | Object ID of groups, service principals or managed identities. For managed identities use the principal ID. For service principals, use the object ID and not the app ID | Must exist                       | `a86fe549-7f87-4873-8b0e-82f0081a0034`                   |
| parTelemetryOptOut       | bool            | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                 | none                             | `false`                                                  |

### roleAssignmentSubscription.bicep

| Parameter                 | Type   | Description                                                                                                                                                              | Requirement                      | Example                                |
| ------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- | -------------------------------------- |
| parRoleAssignmentNameGuid | string | A GUID representing the role assignment name.  Default:  guid(subscription().subscriptionId, parRoleDefinitionId, parAssigneeObjectId)                                   | Unique GUID                      | `f3b171da-2023-4508-b467-042a53f4cd5d` |
| parRoleDefinitionId       | string | Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)                                                                         | Must exist                       | `acdd72a7-3385-48ef-bd42-f606fba81ae7` |
| parAssigneePrincipalType  | string | Principal type of the assignee. Allowed values are `Group` (Security Group) or `ServicePrincipal` (Service Principal or System/User Assigned Managed Identity)           | One of [Group, ServicePrincipal] | `ServicePrincipal`                     |
| parAssigneeObjectId       | string | Object ID of groups, service principals or managed identities. For managed identities use the principal ID. For service principals, use the object ID and not the app ID | Must exist                       | `a86fe549-7f87-4873-8b0e-82f0081a0034` |
| parTelemetryOptOut        | bool   | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                 | none                             | `false`                                |

### roleAssignmentSubscriptionMany.bicep

| Parameter                | Type            | Description                                                                                                                                                              | Requirement                      | Example                                                                           |
| ------------------------ | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- | --------------------------------------------------------------------------------- |
| parSubscriptionIds       | Array of string | A list of subscription ids that will be used for role assignment (i.e. 4f9f8765-911a-4a6d-af60-4bc0473268c0)  Default = []                                               | Must exist                       | `['4f9f8765-911a-4a6d-af60-4bc0473268c0','82f7705e-3386-427b-95b7-cbed91ab29a7']` |
| parRoleDefinitionId      | string          | Role Definition ID(i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)                                                                          | Must exist                       | `acdd72a7-3385-48ef-bd42-f606fba81ae7`                                            |
| parAssigneePrincipalType | string          | Principal type of the assignee. Allowed values are `Group` (Security Group) or `ServicePrincipal` (Service Principal or System/User Assigned Managed Identity)           | One of [Group, ServicePrincipal] | `ServicePrincipal`                                                                |
| parAssigneeObjectId      | string          | Object ID of groups, service principals or managed identities. For managed identities use the principal ID. For service principals, use the object ID and not the app ID | Must exist                       | `a86fe549-7f87-4873-8b0e-82f0081a0034`                                            |
| parTelemetryOptOut       | bool            | Set Parameter to true to Opt-out of deployment telemetry                                                                                                                 | none                             | `false`                                                                           |

## Outputs

*This module does not produce any outputs.*

## Deployment

In this example, the built-in Reader role will be assigned to a Service Principal account at the `alz-platform` management group scope.  The inputs for this module are defined in `parameters/roleAssignmentManagementGroup.*.parameters.all.json`.

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI

```bash
# For Azure global regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep \
  --parameters @infra-as-code/bicep/modules/roleAssignments/parameters/roleAssignmentManagementGroup.servicePrincipal.parameters.all.json \
  --management-group-id alz-platform \
  --location eastus
```
OR
```bash
# For Azure China regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep \
  --parameters @infra-as-code/bicep/modules/roleAssignments/parameters/roleAssignmentManagementGroup.servicePrincipal.parameters.all.json \
  --management-group-id alz-platform \
  --location chinaeast2
```

### PowerShell

```powershell
# For Azure global regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/roleAssignments/parameters/roleAssignmentManagementGroup.servicePrincipal.parameters.all.json `
  -ManagementGroupId alz-platform `
  -Location eastus
```
OR
```powershell
# For Azure China regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/roleAssignments/parameters/roleAssignmentManagementGroup.servicePrincipal.parameters.all.json `
  -ManagementGroupId alz-platform `
  -Location chinaeast2
```

## Bicep Visualizer

### Single Management Group Role Assignment

![Bicep Visualizer - Single Management Group Role Assignment](media/bicepVisualizerMg.png "Bicep Visualizer - Single Management Group Role Assignment")

### Many Management Group Role Assignments

![Bicep Visualizer - Many Management Group Role Assignments](media/bicepVisualizerMgMany.png "Bicep Visualizer - Many Management Group Role Assignments")

### Single Subscription Role Assignment

![Bicep Visualizer - Single Subscription Role Assignment](media/bicepVisualizerSub.png "Bicep Visualizer - Single Subscription Role Assignment")

### Many Subscription Role Assignments

![Bicep Visualizer - Many Subscription Role Assignments](media/bicepVisualizerSubMany.png "Bicep Visualizer - Many Subscription Role Assignments")
