<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Deployment Flow - Hub and Spoke
<!-- markdownlint-restore -->

### Intro

This deploys a [hub and spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) network topology to the Azure Landing Zone foundation.

> Please review and run the [Deployment Flow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) before running these modules.

### Module Deployment Sequence

There are 2 options available to deploy the Hub & Spoke networking topology. One that uses an orchestration module for the spoke networking and one that does not.

We recommend using option 1 were possible as the orchestration module has some added benefits, like subscription placement, as well as the spoke networking.

#### Option 1 - Using Orchestration Module

This option does utilize an orchestration module (a module that wrap/call other modules).

| Deployment Order | Module                      | Description                                                                                                                                                                                                                                                                                                                                                                                                            | Prerequisites                                                         | Module Documentation                                                                                                                              |
| :--------------: | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
|        1         | Hub Networking              | Creates Hub networking infrastructure with Azure Firewall to support Hub & Spoke network topology in the `Connectivity` subscription.                                                                                                                                                                                                                                                                                  | Management Groups, Subscription for Hub Networking.                   | [infra-as-code/bicep/modules/hubNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/hubNetworking)               |
|        2         | Hub Peered Spoke Networking | Creates Spoke networking infrastructure for workloads with Virtual Network Peering (optional) to support Hub & Spoke network topology or Virtual Hub Connection (optional). Also can optionally place Subscription in specified Management Group, create VNet Peering in both directions, create UDR and configure a next hop IP for the default route (`0.0.0.0/0`) ***Review docs of module for more information.*** | Management Groups, Hub Networking & Subscription for spoke networking | [infra-as-code/bicep/orchestration/hubPeeredSpoke](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/hubPeeredSpoke) |

#### Option 2 - No Orchestration Module

This option doesn't utilize any orchestration modules (modules that wrap/call other modules).

| Deployment Order | Module         | Description                                                                                                                                                                 | Prerequisites                                                         | Module Documentation                                                                                                                    |
| :--------------: | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
|        1         | Hub Networking | Creates Hub networking infrastructure with Azure Firewall to support Hub & Spoke network topology in the `Connectivity` subscription.                                       | Management Groups, Subscription for Hub Networking.                   | [infra-as-code/bicep/modules/hubNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/hubNetworking)     |
|        2         | Spoke Network  | Creates Spoke networking infrastructure for workloads to support Hub & Spoke network topology.  Spoke subscriptions are used for deploying construction sets and workloads. | Management Groups, Hub Networking & Subscription for spoke networking | [infra-as-code/bicep/modules/spokeNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/spokeNetworking) |
|        3         | VNet Peering   | Creates VNet peering between 2 VNets (e.g. Hub & Spoke). ***Make sure to run this module twice, once in each direction. e.g. Hub to Spoke and then Spoke to Hub***          | Management Groups, Hub Networking & Spoke Network                     | [infra-as-code/bicep/modules/vnetPeering](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vnetPeering)         |
