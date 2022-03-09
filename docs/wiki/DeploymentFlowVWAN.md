<!-- markdownlint-disable -->
## Azure Landing Zones Bicep - Deployment Flow - Virtual WAN
<!-- markdownlint-restore -->

### Intro

This deploys a hub and spoke network [topology with Azure Virtual WAN](https://docs.microsoft.com/en-us/azure/architecture/networking/hub-spoke-vwan-architecture) to the Azure Landing Zone foundation. This connectivity approach uses Virtual WAN (VWAN) to replace hubs as a managed service. Spoke virtual networks peer with the VWAN virtual hub.

> Please review and run the [Deployment Flow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow) before running these modules.

### Module Deployment Sequence

Modules in this reference implementation must be deployed in the following order to ensure consistency across the environment:

| Order | Module                                 | Description                                                                                                                                                                                | Prerequisites                                                          | Module Documentation                                                                                                                                                  |
| :---: | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1   | Virtual WAN Connectivity                      | Deploys the Virtual WAN network topology and its components according to the Azure Landing Zone conceptual architecture.                                                                                          | Management Groups, Subscription for vWAN connectivity.                    | [infra-as-code/bicep/modules/vwanConnectivity](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/vwanConnectivity)                             |
|   2   | VNet Peering with vWAN                        | Connect a virtual network to a Virtual WAN hub.                                                                                          | Management Groups, Subscription for spoke VNet, vWAN Connectivity Module                    | _**Coming soon**_                            |
