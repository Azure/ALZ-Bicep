<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Deployment Flow - Hub and Spoke
<!-- markdownlint-restore -->

### Intro

This deploys a [hub and spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) network topology to the Azure Landing Zone foundation.

> Please review and run the [Deployment Flow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) before running these modules.

### Module Deployment Sequence

Modules in this reference implementation must be deployed in the following order to ensure consistency across the environment:

| Order | Module                                 | Description                                                                                                                                                                                | Prerequisites                                                          | Module Documentation                                                                                                                                                  |
| :---: | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1   | Hub Networking                         | Creates Hub networking infrastructure with Azure Firewall to support Hub & Spoke network topology in the `Connectivity` subscription.                                                      | Management Groups, Subscription for Hub Networking.                    | [infra-as-code/bicep/modules/hubNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/hubNetworking)                                   |
|   2   | Corp Connected Spoke Network           | Creates Spoke networking infrastructure with Virtual Network Peering to support Hub & Spoke network topology.  Spoke subscriptions are used for deploying construction sets and workloads. | Management Groups, Hub Networking & Subscription for spoke networking  | [infra-as-code/bicep/modules/spokeNetworking](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/spokeNetworking)                               |
