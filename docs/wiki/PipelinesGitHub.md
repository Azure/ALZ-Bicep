<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - GitHub Actions Pipeline
<!-- markdownlint-restore -->

### Intro

This sample pipeline is provided as an example that is intended to be used for learning purposes.

Please review the [Pipelines Overview](https://github.com/Azure/ALZ-Bicep/wiki/PipelinesOverview) and [Deployment Flow Prerequisites](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow#prerequisites) before running the pipeline. A successful run will require updated module parameter files and a deployment identity.

### Sample code

```yaml
name: ALZ GitHub Actions deployment pipeline

on: [workflow_dispatch]

env:
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
  runNumber: ${{ github.run_number }}

jobs:
  bicep_tenant_deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: '${{ secrets.AZURE_CREDENTIALS }}'

      - name: Az CLI Deploy Management Groups
        id: create_mgs
        shell: bash
        run: |
            az deployment tenant create --template-file infra-as-code/bicep/modules/managementGroups/managementGroups.bicep --parameters parTopLevelManagementGroupPrefix=${{ env.ManagementGroupPrefix }} parTopLevelManagementGroupDisplayName="${{ env.TopLevelManagementGroupDisplayName }}" --location ${{ env.Location }} --name create_mgs-${{ env.runNumber }}

      - name: Deploy Custom Policy Definitions
        id: create_policy_defs
        uses: azure/arm-deploy@v1
        with:
          scope: managementgroup
          managementGroupId: ${{ env.ManagementGroupPrefix }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/policy/definitions/customPolicyDefinitions.bicep
          parameters: infra-as-code/bicep/modules/policy/definitions/parameters/customPolicyDefinitions.parameters.all.json
          deploymentName: create_policy_defs-${{ env.runNumber }}
          failOnStdErr: false
        
      - name: Deploy Custom Role Definitions
        id: create_rbac_roles
        uses: azure/arm-deploy@v1
        with:
          scope: managementgroup
          managementGroupId: ${{ env.ManagementGroupPrefix }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/customRoleDefinitions/customRoleDefinitions.bicep
          parameters: infra-as-code/bicep/modules/customRoleDefinitions/parameters/customRoleDefinitions.parameters.all.json
          deploymentName: create_rbac_roles-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Logging Resource Group
        id: create_logging_rg
        uses: azure/arm-deploy@v1
        with:
          scope: subscription
          subscriptionId: ${{ env.LoggingSubId }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/resourceGroup/resourceGroup.bicep
          parameters: parResourceGroupName=${{ env.LoggingResourceGroupName }} parLocation=${{ env.Location }}
          deploymentName: create_logging_rg-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Logging
        id: create_logging
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ env.LoggingSubId }}
          resourceGroupName: ${{ env.LoggingResourceGroupName }}
          template: infra-as-code/bicep/modules/logging/logging.bicep
          parameters: infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json
          deploymentName: create_logging-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Hub Networking Resource Group
        id: create_hub_network_rg
        uses: azure/arm-deploy@v1
        with:
          scope: subscription
          subscriptionId: ${{ env.HubNetworkSubId }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/resourceGroup/resourceGroup.bicep
          parameters: parResourceGroupName=${{ env.HubNetworkResourceGroupName }} parLocation=${{ env.Location }}
          deploymentName: create_hub_network_rg-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Hub Network
        id: create_hub_network
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ env.HubNetworkSubId }}
          resourceGroupName: ${{ env.HubNetworkResourceGroupName }}
          template: infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep
          parameters: infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json
          deploymentName: create_hub_network-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Role Assignment
        id: create_role_assignment
        uses: azure/arm-deploy@v1
        with:
          scope: managementgroup
          managementGroupId: ${{ env.RoleAssignmentManagementGroupId }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep
          parameters: infra-as-code/bicep/modules/roleAssignments/parameters/roleAssignmentManagementGroup.servicePrincipal.parameters.all.json
          deploymentName: create_role_assignment-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Subscription Placement
        id: create_subscription_placement
        uses: azure/arm-deploy@v1
        with:
          scope: managementgroup
          managementGroupId: ${{ env.ManagementGroupPrefix }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.bicep
          parameters: infra-as-code/bicep/modules/subscriptionPlacement/parameters/subscriptionPlacement.parameters.all.json
          deploymentName: create_subscription_placement-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Default Policy Assignments
        id: create_policy_assignments
        uses: azure/arm-deploy@v1
        with:
          scope: managementgroup
          managementGroupId: ${{ env.ManagementGroupPrefix }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep
          parameters: infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json
          deploymentName: create_policy_assignments-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Spoke Networking Resource Group
        id: create_spoke_network_rg
        uses: azure/arm-deploy@v1
        with:
          scope: subscription
          subscriptionId: ${{ env.SpokeNetworkSubId }}
          region: ${{ env.Location }}
          template: infra-as-code/bicep/modules/resourceGroup/resourceGroup.bicep
          parameters: parResourceGroupName=${{ env.SpokeNetworkResourceGroupName }} parLocation=${{ env.Location }}
          deploymentName: create_spoke_network_rg-${{ env.runNumber }}
          failOnStdErr: false

      - name: Deploy Spoke Network
        id: create_spoke_network
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ env.SpokeNetworkSubId }}
          resourceGroupName: ${{ env.SpokeNetworkResourceGroupName }}
          template: infra-as-code/bicep/modules/spokeNetworking/spokeNetworking.bicep
          parameters: infra-as-code/bicep/modules/spokeNetworking/parameters/spokeNetworking.parameters.all.json
          deploymentName: create_spoke_network-${{ env.runNumber }}
          failOnStdErr: false
```