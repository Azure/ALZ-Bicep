<!-- markdownlint-disable -->
## Azure Landing Zones Bicep Repo - Wiki
<!-- markdownlint-restore -->

![Bicep Logo](media/bicep-logo.png)

Welcome to the wiki of the Azure Landing Zones Bicep repo. This repo contains the Azure Landing Zone Bicep modules that help you create and implement the [Azure Landing Zone Conceptual Architecture](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) in a modular approach.

Artefacts like policies etc. are pulled down from the [`Azure/Enterprise-Scale` repo](https://github.com/Azure/Enterprise-Scale) to ensure the choice of tooling to implement the architecture, produce the same outputs.

> Have you seen our page in the Azure Architecture Center here: [Azure landing zones - Bicep modules design considerations][aac_article]

## Navigation

* [Wiki Home][wiki_home]
* [Deployment Flow][wiki_deployment_flow]
  * [Network Topology: Hub and Spoke][wiki_deployment_flow_hs]
  * [Network Topology: Virtual WAN][wiki_deployment_flow_vwan]
* [Consumer Guide][wiki_consumer_guide]
* [How Does ALZ-Bicep Implement Azure Policies?][wiki_policy_deep_dive]
  * [Adding Custom Azure Policy Definitions][wiki_policy_defs]
  * [Assigning Azure Policies][wiki_policy_assignments]
* [Contributing][wiki_contributing]
* [Telemetry Tracking Using Customer Usage Attribution (PID)][wiki_cuaid]
* [Azure Container Registry Deployment - Private Bicep Registry][wiki_acrdeploy]
* [Frequently Asked Questions][wiki_faq]
* [Sample Pipelines][wiki_pipelines]
  * [GitHub Actions][wiki_pipelines_gh]
  * [Azure DevOps][wiki_pipelines_ado]
* [Code Tours][code_tours]

## Azure Enablement Show Videos

We have created a short 3-part series of video on the Azure Enablement Show that can be found below:
<!-- markdownlint-disable -->
### Part 1 - Introduction to Azure Landing Zones Bicep

[![Part 1 - Introduction to Azure Landing Zones Bicep](https://img.youtube.com/vi/-pZNrH1GOxs/hqdefault.jpg)](https://aka.ms/azenable/94)

### Part 2 - Azure Landing Zones Bicep - Enabling platform services

[![Part 2 - Azure Landing Zones Bicep - Enabling platform services](https://img.youtube.com/vi/FNT0ZtUxYKQ/hqdefault.jpg)](https://aka.ms/azenable/95)

### Part 3 - Azure Landing Zones Bicep - Enabling landing zones

[![Part 3 - Azure Landing Zones Bicep - Enabling landing zones](https://img.youtube.com/vi/cZ7IN3zGbyM/hqdefault.jpg)](https://aka.ms/azenable/96)
<!-- markdownlint-restore -->





 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

<!--
The following link references should be copied from `_sidebar.md` in the `./docs/wiki/` folder.
Replace `./` with `https://github.com/Azure/ALZ-Bicep/wiki/` when copying to here.
-->

[wiki_home]:                                  https://github.com/Azure/ALZ-Bicep/wiki/home "Wiki - Home"
[wiki_deployment_flow]:                            https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow "Wiki - Deployment Flow"
[wiki_deployment_flow_hs]:                            https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlowHS "Wiki - Deployment Flow - Hub and Spoke"
[wiki_deployment_flow_vwan]:                            https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlowVWAN "Wiki - Deployment Flow - Virtual WAN"
[wiki_consumer_guide]:                          https://github.com/Azure/ALZ-Bicep/wiki/ConsumerGuide "Wiki - Consumer Guide"
[wiki_policy_deep_dive]:                        https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive "Wiki - Policy Deep Dive"
[wiki_policy_defs]:                        https://github.com/Azure/ALZ-Bicep/wiki/AddingPolicyDefs "Wiki - Policy Definitions"
[wiki_policy_assignments]:                        https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies "Wiki - Policy Assignments"
[wiki_contributing]:                          https://github.com/Azure/ALZ-Bicep/wiki/Contributing "Wiki - Contributing"
[wiki_acrdeploy]:                          https://github.com/Azure/ALZ-Bicep/wiki/ACRDeployment "Wiki - Private Bicep Registry"
[wiki_cuaid]:                          https://github.com/Azure/ALZ-Bicep/wiki/CustomerUsage "Wiki - Telemetry Usage ID"
[wiki_faq]:                          https://github.com/Azure/ALZ-Bicep/wiki/FAQ "Wiki - FAQs"
[wiki_pipelines]:                          https://github.com/Azure/ALZ-Bicep/wiki/PipelinesOverview "Wiki - Sample Pipelines"
[wiki_pipelines_gh]:                          https://github.com/Azure/ALZ-Bicep/wiki/PipelinesGitHub "Wiki - Sample Pipelines - GitHub Actions"
[wiki_pipelines_ado]:                          https://github.com/Azure/ALZ-Bicep/wiki/PipelinesADO "Wiki - Sample Pipelines - Azure DevOps"
[code_tours]:                                   https://github.com/Azure/ALZ-Bicep/wiki/CodeTour "Wiki - Code tours"
[aes_part_1]:                                   https://aka.ms/azenable/94 "Part 1 - Introduction to Azure Landing Zones Bicep"
[aes_part_2]:                                   https://aka.ms/azenable/95 "Part 2 - Enabling platform services"
[aes_part_3]:                                   https://aka.ms/azenable/96 "Part 3 - Enabling landing zones"
[aac_article]:                                  https://docs.microsoft.com/azure/architecture/landing-zones/bicep/landing-zone-bicep "Azure Architecture Center - Azure landing zones - Bicep modules design considerations"

