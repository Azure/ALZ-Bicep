<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Azure DevOps Pipeline
<!-- markdownlint-restore -->

### Intro

This sample pipeline is provided as an example that is intended to be used for learning purposes.

Please review the [Pipelines Overview](https://github.com/Azure/ALZ-Bicep/wiki/PipelinesOverview) and [Deployment Flow Prerequisites](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow#prerequisites) before running the pipeline. A successful run will require updated module parameter files and a deployment identity.

### Sample Code

```yaml
trigger: none

pool:
  vmImage: ubuntu-latest

variables:
  ServiceConnectionName: "ALZPipelineConnection"
  ManagementGroupPrefix: "alz"
  TopLevelManagementGroupDisplayName: "Azure Landing Zones"
  Location: "eastus"
  LoggingSubId: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  LoggingResourceGroupName: "alz-logging"
  HubNetworkSubId: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  HubNetworkResourceGroupName: "Hub_Networking_POC"
  RoleAssignmentManagementGroupId: "alz-platform"
  SpokeNetworkSubId: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  SpokeNetworkResourceGroupName: "Spoke_Networking_POC"
  RunNumber: $(Build.BuildNumber)

jobs:
- job:
  steps:

  - task: AzureCLI@2
    displayName: Az CLI Deploy Management Groups
    name: create_mgs
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment tenant create \
        --template-file infra-as-code/bicep/modules/managementGroups/managementGroups.bicep \
        --parameters parTopLevelManagementGroupPrefix=$(ManagementGroupPrefix) parTopLevelManagementGroupDisplayName="$(TopLevelManagementGroupDisplayName)" \
        --location $(Location) \
        --name create_mgs-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Custom Policy Definitions
    name: create_policy_defs
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment mg create \
        --template-file infra-as-code/bicep/modules/policy/definitions/customPolicyDefinitions.bicep  \
        --parameters @infra-as-code/bicep/modules/policy/definitions/parameters/customPolicyDefinitions.parameters.all.json \
        --location $(Location) \
        --management-group-id $(ManagementGroupPrefix) \
        --name create_policy_defs-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Custom Role Definitions
    name: create_rbac_roles
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment mg create \
        --template-file infra-as-code/bicep/modules/customRoleDefinitions/customRoleDefinitions.bicep \
        --parameters @infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json \
        --location $(Location) \
        --management-group-id $(ManagementGroupPrefix) \
        --name create_rbac_roles-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Logging Resource Group
    name: create_logging_rg
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az account set --subscription $(LoggingSubId)
        az deployment sub create \
        --template-file infra-as-code/bicep/modules/resourceGroup/resourceGroup.bicep \
        --parameters parResourceGroupName=$(LoggingResourceGroupName) parLocation=$(Location) \
        --location $(Location) \
        --name create_logging_rg-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Logging
    name: create_logging
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az account set --subscription $(LoggingSubId)
        az deployment group create \
        --resource-group $(LoggingResourceGroupName) \
        --template-file infra-as-code/bicep/modules/logging/logging.bicep \
        --parameters @infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json \
        --name create_logging-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Hub Network Resource Group
    name: create_hub_network_rg
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az account set --subscription $(HubNetworkSubId)
        az deployment sub create \
        --template-file infra-as-code/bicep/modules/resourceGroup/resourceGroup.bicep \
        --parameters parResourceGroupName=$(HubNetworkResourceGroupName) parLocation=$(Location) \
        --location $(Location) \
        --name create_hub_network_rg-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Hub Network
    name: create_hub_network
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az account set --subscription $(HubNetworkSubId)
        az deployment group create \
        --resource-group $(HubNetworkResourceGroupName) \
        --template-file infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep \
        --parameters @infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json \
        --name create_hub_network-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Role Assignment
    name: create_role_assignment
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment mg create \
        --template-file infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep \
        --parameters @infra-as-code/bicep/modules/roleAssignments/parameters/roleAssignmentManagementGroup.servicePrincipal.parameters.all.json \
        --location $(Location) \
        --management-group-id $(RoleAssignmentManagementGroupId) \
        --name create_role_assignment-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Subscription Placement
    name: create_subscription_placement
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment mg create \
        --template-file infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.bicep \
        --parameters @infra-as-code/bicep/modules/subscriptionPlacement/parameters/subscriptionPlacement.parameters.all.json \
        --location $(Location) \
        --management-group-id $(ManagementGroupPrefix) \
        --name create_subscription_placement-$(RunNumber)

  - task: AzureCLI@2
    displayName: Deploy Default Policy Assignments
    name: create_policy_assignments
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment mg create \
        --template-file infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep \
        --parameters @infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json \
        --location $(Location) \
        --management-group-id $(ManagementGroupPrefix) \
        --name create_policy_assignments-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Spoke Network Resource Group
    name: create_spoke_network_rg
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az account set --subscription $(SpokeNetworkSubId)
        az deployment sub create \
        --template-file infra-as-code/bicep/modules/resourceGroup/resourceGroup.bicep \
        --parameters parResourceGroupName=$(SpokeNetworkResourceGroupName) parLocation=$(Location) \
        --location $(Location) \
        --name create_spoke_network_rg-$(RunNumber)

  - task: AzureCLI@2
    displayName: Az CLI Deploy Spoke Network
    name: create_spoke_network
    inputs:
      azureSubscription: $(ServiceConnectionName)
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az account set --subscription $(SpokeNetworkSubId)
        az deployment group create \
        --resource-group $(SpokeNetworkResourceGroupName) \
        --template-file infra-as-code/bicep/modules/spokeNetworking/spokeNetworking.bicep \
        --parameters @infra-as-code/bicep/modules/spokeNetworking/parameters/spokeNetworking.parameters.all.json \
        --name create_spoke_network-$(RunNumber)    
```