<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Deployment Flow - Virtual WAN
<!-- markdownlint-restore -->

### Intro

This deploys a hub and spoke network [topology with Azure Virtual WAN](https://docs.microsoft.com/en-us/azure/architecture/networking/hub-spoke-vwan-architecture) to the Azure Landing Zone foundation. This connectivity approach uses Virtual WAN (VWAN) to replace hubs as a managed service. Spoke virtual networks peer with the VWAN virtual hub.

> Please review and run the [Deployment Flow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) before running these modules.

### Module Deployment Sequence

There are 2 options available to deploy the Hub & Spoke networking topology. One that uses an orchestration module for the spoke networking and one that does not.

We recommend using option 1 were possible as the orchestration module has some added benefits, like subscription placement, as well as the spoke networking.

#### Option 1 - Using Orchestration Module

This option does utilize an orchestration module (a module that wrap/call other modules).

| Deployment Order | Module                      | Description                                                                                                                                                                                                                                                                                                                                                                                                            | Prerequisites                                                         | Module Documentation                                                                                                                              |
| :--------------: | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
|        1         | Virtual WAN Connectivity    | Deploys the Virtual WAN network topology and its components according to the Azure Landing Zone conceptual architecture.                                                                                                                                                                                                                                                                                               | Management Groups, Subscription for vWAN connectivity.                | [infra-as-code/bicep/modules/vwanConnectivity](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vwanConnectivity)         |
|        2         | Hub Peered Spoke Networking | Creates Spoke networking infrastructure for workloads with Virtual Network Peering (optional) to support Hub & Spoke network topology or Virtual Hub Connection (optional). Also can optionally place Subscription in specified Management Group, create VNet Peering in both directions, create UDR and configure a next hop IP for the default route (`0.0.0.0/0`) ***Review docs of module for more information.*** | Management Groups, Hub Networking & Subscription for spoke networking | [infra-as-code/bicep/orchestration/hubPeeredSpoke](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/hubPeeredSpoke) |

#### Option 2 - No Orchestration Module

This option doesn't utilize any orchestration modules (modules that wrap/call other modules).

| Order | Module                              | Description                                                                                                                                                  | Prerequisites                                                                                   | Module Documentation                                                                                                                      |
| :---: | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
|   1   | Virtual WAN Connectivity            | Deploys the Virtual WAN network topology and its components according to the Azure Landing Zone conceptual architecture.                                     | Management Groups, Subscription for vWAN connectivity.                                          | [infra-as-code/bicep/modules/vwanConnectivity](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vwanConnectivity) |
|   2   | Spoke Network                       | Creates Spoke networking infrastructure for workloads to support VWAN topology.  Spoke subscriptions are used for deploying construction sets and workloads. | Management Groups, Hub Networking & Subscription for spoke networking                           | [infra-as-code/bicep/modules/spokeNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/spokeNetworking)   |
|   2   | VNet Connection (Peering) with VWAN | Connect a spoke virtual network to a Virtual WAN virtual hub.                                                                                                | Management Groups, Subscription for spoke VNet, vwanConnectivity Module, spokeNetworking module | [infra-as-code/bicep/modules/vnetPeeringVwan](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vnetPeeringVwan)   |