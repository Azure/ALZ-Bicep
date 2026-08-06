# ALZ alerting landscape

This is a point-in-time reference for Azure landing zone (ALZ) alerting, Azure Monitor Baseline Alerts (AMBA), and the CloudHealth health-model modules in this folder. The catalog is pinned to AMBA commit [`ba0266b35d2b3f6385beb37643663e0254de2a0a`](https://github.com/Azure/azure-monitor-baseline-alerts/tree/ba0266b35d2b3f6385beb37643663e0254de2a0a), release `2026-06-03`, and was researched on 2026-08-02. AMBA changes frequently, so all counts and defaults below are point-in-time facts rather than a promise about a later release.

## What ALZ and CAF adopters are expected to alert on

Microsoft does not prescribe one universal alert list. Alert selection and thresholds depend on the deployed services, architecture, usage, criticality, and service-level objectives. AMBA is therefore a customizable starting baseline, not a complete mandatory catalog.

### Platform-level expectations

| Area | Expected monitoring and alerting | Source |
|------|----------------------------------|--------|
| Estate and service health | Centrally monitor Azure incidents, outages, planned maintenance, advisories, Resource Health, shared services, and SLA evidence. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor), [management platform](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform) |
| Identity | Centrally monitor user interactions, risky sign-ins, sign-in failures, audit changes, and directory-service health. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor), [identity and access](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access) |
| Connectivity | Monitor shared VPN and ExpressRoute, Firewall, virtual networks and WAN, DNS, traffic, connectivity, capacity, packet loss, and security-related network activity. | [Network topology and connectivity](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) |
| Management and logging | Centralize platform Activity Logs, diagnostic logs, and metrics. Alert on destructive or sensitive control-plane changes and logging-capacity failures. Protect the central Log Analytics workspaces and keys. | [Management platform](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform) |
| Security and compliance | Centrally monitor identity and network security, threats, vulnerabilities, configuration drift, and policy compliance through services such as Defender for Cloud, Sentinel, Entra monitoring, and Azure Policy. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) |
| Business continuity and disaster recovery | Monitor backup, restore, replication, and failover health against recovery time and recovery point requirements. | [BCDR design area](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery) |
| Notification and routing | Configure and test action groups. CAF guidance calls for at least one action group per subscription and at least email as a notification channel. | [Monitor platform landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-monitor) |
| Hierarchy and scope | Assign platform initiatives to the management groups that own the resources, and put cross-estate Service Health and notification assets high enough to reach the intended subscriptions. | [Monitor platform landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-monitor) |

> “Monitoring service health is the bare minimum for monitoring your cloud estate.”
>
> “Determine which critical events must trigger alerts, such as resource outages, performance threshold breaches, or security anomalies.”

Both quotations are from [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor).

### Application-level expectations

| Area | Expected monitoring and alerting | Source |
|------|----------------------------------|--------|
| Application functionality | Alert when critical workflows fail to complete or produce invalid results, rather than relying only on infrastructure utilization. | [WAF reliability monitoring](https://learn.microsoft.com/en-us/azure/well-architected/reliability/monitoring) |
| User experience and critical flows | Monitor success, failure, latency, SLO attainment, and synthetic or end-to-end checks for business-critical user and system flows. | [WAF reliability monitoring](https://learn.microsoft.com/en-us/azure/well-architected/reliability/monitoring) |
| Application telemetry | Workload teams instrument application logs, metrics, traces, exceptions, dependencies, and business events, commonly through Application Insights and OpenTelemetry. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) |
| Workload resources | Configure workload-specific resource logs, metrics, dashboards, and alerts, including relevant Service Health and Resource Health effects. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) |
| Workload health model | Derive healthy, degraded, and unhealthy states from application, infrastructure, dependency, and user-experience signals. Alert on meaningful state transitions. | [WAF health modeling](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/health-modeling) |
| Health endpoints | Expose and externally probe health endpoints. Validate operation, content, response time, dependencies, certificates, and DNS where relevant. | [Health endpoint monitoring pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) |
| Workload security, compliance, cost, and data | Implement workload-specific security monitoring, remediate policy findings, manage budgets and cost anomalies, and satisfy central data-governance standards. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) |
| Ownership | The platform team establishes standards and shared tooling, while workload teams remain accountable for operating their applications and resources. | [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) |

> “At the workload level, you need to gather telemetry (application logs, metrics, and traces) on your application code and execution to identify issues and optimize performance.”

This quotation is from [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor).

### Management-group scoping model

The ALZ hierarchy gives alert initiatives an ownership and inheritance model:

- **Intermediate Root** contains the complete ALZ hierarchy. Service and Resource Health plus notification assets are assigned here in the AMBA pattern.
- **Platform** contains **Identity**, **Management**, and **Connectivity**. Their initiatives attach to the corresponding child management groups.
- **Landing Zones** contains workload groups such as **Corp** and **Online**. Workload-oriented initiatives attach here.
- **Sandbox** isolates experimentation.
- **Decommissioned** holds canceled landing zones pending deletion.
- Current CAF guidance also includes **Security** and **Local** management groups.

The hierarchy meanings come from [CAF management-group guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups). Sandbox and Decommissioned are not children of Landing Zones, so a Landing Zones assignment must not be assumed to cover them.

### WAF recommendations RE:10 and OE:07

The current Well-Architected Framework identifiers are:

- **RE:02** identifies and rates user and system flows.
- **RE:03** uses failure mode analysis to identify dependencies, failures, and mitigations.
- **RE:04** defines reliability and recovery targets that become inputs to the health model.
- **RE:10** says to continuously measure and track system health across components and critical flows. Its alert design combines metrics, logs, traces, synthetic checks, and platform signals in a health model.
- **OE:07** defines the monitoring stack across infrastructure and code. It recommends actionable, contextual alerts and alerting on health-state transitions instead of isolated thresholds.

RE:02 through RE:04 are inputs, not substitutes for the RE:10 monitoring recommendation. See the [reliability checklist](https://learn.microsoft.com/en-us/azure/well-architected/reliability/checklist), [RE:10 monitoring guidance](https://learn.microsoft.com/en-us/azure/well-architected/reliability/monitoring), and [OE:07 observability guidance](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability).

> “Design alerts so they clearly point to something worth acting on, and ground them in a health model that represents the system using simple states like healthy, degraded, and unhealthy.”
>
> “Use a health model that aggregates multiple correlated signals into health states, then alert on state transitions, not isolated metric thresholds.”

## Main concerns of someone managing an org's ALZ

The following concerns are a synthesis of CAF/WAF responsibilities and the issue evidence. “Synthesis” means the wording is an operational inference, not a quotation or proof that every organization reports the same concern.

| Concern | Evidence and interpretation |
|---------|-----------------------------|
| Estate-wide visibility versus per-team autonomy | CAF assigns central teams responsibility for health, security, compliance, cost, data, and shared services while workload teams monitor workloads. **Synthesis:** the operator must preserve a comparable estate baseline without taking ownership away from workload teams. [CAF monitoring](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/monitor) |
| Knowing whether a landing zone is actually healthy | RE:10 asks for system health across components and critical flows, while [#390](https://github.com/Azure/azure-monitor-baseline-alerts/issues/390) asks why each alert matters and what action to take. **Synthesis:** a list of alert instances does not by itself state whether a landing zone is healthy. |
| Governance and compliance drift | [#69, “Several Policies became Non Compliant since 10/3 with reason - NoRegisteredProviderFound”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/69) reports that remediation succeeded while definitions remained noncompliant. This makes policy state and deployed state difficult to reconcile. |
| Notification routing and ownership | CAF requires action groups, and [#410, “Action Group Missing from Alert Rules”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/410) shows that notification assets and remediation order are operational dependencies. **Synthesis:** receiving an alert is not enough unless the accountable team is known and reachable. |
| Change safety | [#630, “While upgrading AMBA to latest version I'm seeing Non-Compliant resources for VM, Connectivity and Notification Policies.”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/630) and [#272](https://github.com/Azure/azure-monitor-baseline-alerts/issues/272) show upgrade and customization friction. **Synthesis:** operators need to change the baseline without silently losing alerts or creating unmaintainable forks. |
| Keeping the baseline current | AMBA changes frequently, and #272 says keeping deltas aligned with Microsoft changes is difficult and time-consuming. **Synthesis:** the operator must distinguish upstream improvements from local tuning and revisit both deliberately. |

## Challenges with AMBA alerts on ALZ (evidenced)

### Alert noise, false positives, and weak default thresholds

- [#103, “Ability to customise/filter Service Health Alerts without config drift?”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/103): “we are seeing a potential issue with a lot of noise on the service health alerts”.
- [#208, “Resource Health fine tuning lacking”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/208): “they are seeing a lot of ResourceHealthUnhealthyAlert”. A later comment says, “The amount of events from ResourceHealth for just one VM that's being powered off is quite overwhelming.”
- [#656, “AVD-HostPool-VM-Available Memory Less Than nGB alerts triggering at startup”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/656): “this creates a lots of false positives...” The operator later said, “No, we just suppressed it in the end as we couldn't get to the bottom of it.”
- [#856, “Monitoring alert rule AFW ApplicationRuleHit Alert”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/856): “It feels like this is chosen at random”. A comment reports “nothing that would seem to merit a Sev1 alert notification”.

For #208, the maintainer response was: “it seems there are no options to further fine tune these alerts”. For #390, maintainers accepted the request for reaction guidance as a good suggestion and left it as a longer-term enhancement.

### Per-resource tuning and exclusions are cumbersome

- [#272, “How to override the default alert threshold values for specific resource names?”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/272): “This becomes rather messy and cumbersome to manage.”
- A #272 comment says, “keeping the deltas up to date with changes pushed by Microsoft is going to be rather difficult and time-consuming to manage.” It also notes that `MonitorDisable` “would also exclude the CPU alert” when only memory needed different treatment.
- [#691, “Custom Threshold Dashboard”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/691): “We're noticing challenges in understanding when, why and which internal team/s are customizing their thresholds via tags.”

The #272 maintainer response says “the concept of override does not exist in Azure Monitor” and explains that dedicated alerts conflict with the at-scale approach. Maintainers later supplied a prototype workbook in #691.

### Policy remediation and compliance are unreliable or hard to troubleshoot

- [#69, “Several Policies became Non Compliant since 10/3 with reason - NoRegisteredProviderFound”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/69): “Remediation actually succeeds yet definitions remain reflecting noncompliance.”
- [#410, “Action Group Missing from Alert Rules”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/410): a user reports “my pipeline is green all the times :)” despite missing alert-processing-rule and action-group resources.
- [#630, “While upgrading AMBA to latest version I'm seeing Non-Compliant resources for VM, Connectivity and Notification Policies.”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/630): “I have completed the remediation tasks a few times today and can confirm that I am still getting the same errors”.
- [#922, “AMBA DINE policies cannot create monitoring resource group when tag policy is set to Deny”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/922): “EPAC remediation tasks complete without error but produce no resources”.

Maintainers said “We were able to see and repro this issue” for #69. For [#907](https://github.com/Azure/azure-monitor-baseline-alerts/issues/907), they said the proposed maintenance-script fix would be incorporated into the next pull request.

### Management-group, subscription-placement, and notification-asset complexity

- [#546, “Alert Rules not deploying to subscriptions under Landing Zones”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/546): “Not really sure how to troubleshoot further as I don't get any errors”.
- A #410 maintainer comment states: “MGs should have subscriptions for the remediations to happen.”
- [#847, “Alerting-ResourceAndServiceHealth tags & actiongroups”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/847): “Everytime we run the remediation it'll fail if we don't and actually exempting them is against our governance.” The “don't” refers to exempting the generated action groups and alert rules from inherited tag policies.

Maintainers explained in #410 that most alerts use alert processing rules rather than direct action-group links, and notification assets must be remediated separately or supplied as bring-your-own notification assets. In #546, the maintainer clarified: “The alerts are only created if resources are there.”

### Log-search alerts have hidden dependencies and can silently fail

- [#749, “Log search queries failing to execute on Heartbeat fail”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/749): “alerts are not being generated when a VM goes offline” even though heartbeat data was present.
- A #749 comment says, “Its when this line is executed that I see the error”, referring to the Azure Resource Graph and Log Analytics join.
- Another #749 comment reports Microsoft Support attributed the failure to “the change in the Kusto cluster from our side”.
- [#508, “deploy-amba-web assignment missing Managed Identity Operator role on UAMI”](https://github.com/Azure/azure-monitor-baseline-alerts/issues/508) documents that deployment query validation also needed workspace-read permission.

The #749 maintainer suspected a backend fault and recommended opening a Microsoft support case. The issue evidence is stronger for silent failures, backend regressions, permissions, and query/tag coupling than for normal query latency.

### Evidence gaps

- **Cost is not an evidenced recurring AMBA complaint.** A GitHub issue search for `cost` in this repository returned only two hits, verified on 2026-08-02: [#847](https://github.com/Azure/azure-monitor-baseline-alerts/issues/847), which mentions a “cost center” tag incidentally, and [#272](https://github.com/Azure/azure-monitor-baseline-alerts/issues/272), which concerns workload SKU capacity cost. Neither is a complaint about AMBA alert-rule, scheduled-query evaluation, or Log Analytics ingestion cost. Cost may still matter in practice; it is simply not evidenced here.
- **There is no recurring demand for built-in correlation or aggregation in the reviewed issue corpus.** Only #390 matched “overall health”. The documented pain is missing context and recommended action (#390), duplicate signals for one resource (#208), and threshold-governance visibility (#691). A health-model benefit must be framed against those facts, not as fulfillment of an evidenced broad feature demand.

## Where a health model helps, and where it does not

Microsoft describes health modeling as combining business context with monitoring data to quantify overall workload health. Entities represent components or logical domains. Signals are metrics, logs, traces, platform health, probes, synthetic checks, or other operational evidence. Relationships express dependencies. The model rolls those inputs into simple states such as healthy, degraded, and unhealthy. See [WAF health modeling](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/health-modeling).

The modules in this folder define Microsoft CloudHealth models, identities, discovery rules, and relationships in an embedded resource-group deployment. A subscription-assigned `DeployIfNotExists` policy evaluates the caller-owned target resource group and deploys that topology during remediation. Domain discovery rules find configured resources, attach recommended and Resource Health signals, discover relationships, and root the discovered domain entities under the model.

Against the documented AMBA pain, a health model can help by:

- attaching operational context and a health-state consequence to signals, which addresses the missing “why” and recommended-action context raised in #390;
- rolling multiple signals for the same entity into one state, which can make duplicate or redundant Resource Health evidence such as #208 easier to interpret without claiming the underlying alerts disappear;
- giving operators a landing-zone or domain-level health view instead of only a wall of individual alerts;
- making signal and entity configuration reviewable alongside the model, which can complement the threshold-governance visibility requested in #691. It does not itself record who changed an AMBA tag or why.

These are defensible mappings to documented pain, not evidence that AMBA users repeatedly requested health modeling.

### What a health model does not solve

- It does not tune AMBA thresholds or decide which per-resource exclusions are correct.
- It does not remove Azure Policy, DINE remediation, management-group scoping, RBAC, or notification-asset complexity.
- It does not fix a log-search query that silently fails because of a backend change, permission, schema, or join problem.
- It adds its own risk because the CloudHealth service and API used by these modules are preview and local compilation does not prove live remediation behavior.
- It still depends on the same underlying signals. Missing, delayed, noisy, or incorrect signals can produce a misleading rollup.

## Catalog of ALZ-relevant AMBA alerts

### Catalog totals

The current non-deprecated ALZ initiatives at the pinned commit contain **135 unique alert rules**, of which **110 are enabled by default**.

| Type | Total | Enabled by default |
|------|------:|-------------------:|
| Metric | 85 | 62 |
| Activity Log | 12 | 11 |
| Service Health | 1 | 1 |
| Resource Health | 1 | 1 |
| Log search | 36 | 35 |
| **Total** | **135** | **110** |

Four deprecated custom Service Health rules and one VM metric policy not referenced by the current VM initiative are excluded. Recovery Services modifies platform monitoring settings and is reported separately because it does not define standalone alert rules with thresholds, windows, and severities.

### Counts by service

| Resource type | Alerts |
|---------------|-------:|
| `Microsoft.Automation/automationAccounts` | 1 |
| `Microsoft.Cdn/profiles` | 4 |
| `Microsoft.Compute/virtualMachines` | 11 |
| `Microsoft.Compute/virtualMachineScaleSets` | 11 |
| `Microsoft.HybridCompute/machines` | 12 |
| `Microsoft.Insights/components` | 2 |
| `Microsoft.KeyVault/managedHSMs` | 3 |
| `Microsoft.KeyVault/vaults` | 5 |
| `Microsoft.Network/applicationGateways` | 8 |
| `Microsoft.Network/azureFirewalls` | 5 |
| `Microsoft.Network/expressRouteCircuits` | 4 |
| `Microsoft.Network/expressRouteGateways` | 4 |
| `Microsoft.Network/expressRoutePorts` | 7 |
| `Microsoft.Network/frontdoors` | 2 |
| `Microsoft.Network/loadBalancers` | 4 |
| `Microsoft.Network/networkSecurityGroups` | 1 |
| `Microsoft.Network/p2sVpnGateways` | 3 |
| `Microsoft.Network/privateDnsZones` | 4 |
| `Microsoft.Network/publicIPAddresses` | 4 |
| `Microsoft.Network/routeTables` | 3 |
| `Microsoft.Network/trafficManagerProfiles` | 1 |
| `Microsoft.Network/virtualHubs` | 6 |
| `Microsoft.Network/virtualNetworkGateways` | 9 |
| `Microsoft.Network/virtualNetworks` | 1 |
| `Microsoft.Network/vpnGateways` | 9 |
| `Microsoft.OperationalInsights/workspaces` | 3 |
| `Microsoft.Resources/subscriptions` | 2 |
| `Microsoft.Storage/storageAccounts` | 2 |
| `Microsoft.Web/serverFarms` | 4 |

### Deployment model and scope mapping

- The top-level template installs custom policy definitions, initiatives, assignments, managed identity, and RBAC. Alert policies generally use `DeployIfNotExists`. Recovery Services uses `Modify`.
- Metric alerts are generally deployed beside the monitored resource. Activity Log, Resource Health, and shared subscription-level scheduled-query alerts are deployed in `rg-amba-monitoring-001`.
- Service and Resource Health plus notification assets attach at Intermediate Root.
- Connectivity attaches to Connectivity, Identity to Identity, and Management to Management.
- VM, VMSS, and Arc initiatives attach to both Platform and Landing Zones.
- Key Management, Load Balancing, Network Changes, Recovery Services, Storage, and Web attach to Landing Zones.
- Existing resources remain noncompliant until remediation runs. AMBA supplies `Start-AMBA-ALZ-Remediation.ps1` for initiative-wide or individual-policy-reference remediation.
- Recovery Services `Modify` policies enable `alertsForAllJobFailures` for Backup and `alertsForAllReplicationIssues` plus `alertsForAllFailoverIssues` for ASR.

Primary sources are [`alzArm.param.json`](https://github.com/Azure/azure-monitor-baseline-alerts/blob/ba0266b35d2b3f6385beb37643663e0254de2a0a/patterns/alz/alzArm.param.json), the [policy-set definitions](https://github.com/Azure/azure-monitor-baseline-alerts/tree/ba0266b35d2b3f6385beb37643663e0254de2a0a/patterns/alz/policySetDefinitions), and the [deployment guidance at the pinned commit](https://github.com/Azure/azure-monitor-baseline-alerts/blob/ba0266b35d2b3f6385beb37643663e0254de2a0a/docs/content/patterns/alz/HowTo/deploy/Introduction-to-deploying-the-ALZ-Pattern.md).

**Default-state gotcha:** the generic AMBA service catalog can say an alert is `enabled` while the ALZ initiative's default policy effect is `disabled`. For an ALZ deployment, the initiative defaults win. AMBA's generated documentation tables also contain stale values for P2S thresholds, Automation TotalJob, Application Insights and Log Analytics windows, ActiveFlows, and Resource Health effects. The tables below prefer `patterns/alz/alzArm.param.json` and policy-set definitions.

### Per-service metric-alert catalog

Period/frequency values are ISO 8601 durations. “Dynamic” means AMBA uses a dynamic threshold rather than a static numeric value.

| Resource type | Alert or alerts | Condition | Period/frequency | Severity | Default |
|---------------|-----------------|-----------|------------------|----------|---------|
| `Microsoft.Automation/automationAccounts` | `resourceName-TotalJob` | Average `TotalJob` > 20 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Cdn/profiles` | `OriginHealthPercentage` | Average < 90 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Cdn/profiles` | `OriginLatency` | Average, dynamic > | PT5M/PT1M | Sev2 | No |
| `Microsoft.Cdn/profiles` | `Percentage4XX`; `Percentage5XX` | Average, dynamic > | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.KeyVault/managedHSMs` | `Availability` | Average < 90 | PT5M/PT1M | Sev1 | No |
| `Microsoft.KeyVault/managedHSMs` | `ServiceApiLatency` | Average > 1000 | PT5M/PT5M | Sev3 | No |
| `Microsoft.KeyVault/vaults` | `Availability` | Average < 90 | PT5M/PT1M | Sev1 | No |
| `Microsoft.KeyVault/vaults` | `SaturationShoebox` | Average > 75 | PT5M/PT1M | Sev1 | No |
| `Microsoft.KeyVault/vaults` | `ServiceApiLatency` | Average > 1000 | PT5M/PT5M | Sev3 | No |
| `Microsoft.KeyVault/vaults` | `ServiceApiResult` | Dynamic > | PT5M/PT5M | Sev2 | No |
| `Microsoft.Network/applicationGateways` | `ApplicationGatewayTotalTime`; `BackendLastByteResponseTime` | Average, dynamic > | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/applicationGateways` | `CapacityUnits`; `ComputeUnits` | Average > 75 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/applicationGateways` | `CpuUtilization` | Average > 80 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/applicationGateways` | `FailedRequests`; `ResponseStatus` | Total, dynamic > | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/applicationGateways` | `UnhealthyHostCount` | Average > 20 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/azureFirewalls` | `ApplicationRuleHit`; `NetworkRuleHit` | Total > 50 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/azureFirewalls` | `FirewallHealth` | Average < 90 | PT5M/PT1M | Sev0 | Yes |
| `Microsoft.Network/azureFirewalls` | `SNATPortUtilization` | Average > 80 | PT5M/PT1M | Sev1 | Yes |
| `Microsoft.Network/expressRouteCircuits` | `ArpAvailability`; `BgpAvailability` | Average < 90 | PT5M/PT1M | Sev0 | Yes |
| `Microsoft.Network/expressRouteCircuits` | `QosDropBitsInPerSecond`; `QosDropBitsOutPerSecond` | Dynamic > | PT5M/PT5M | Sev2 | Yes |
| `Microsoft.Network/expressRouteGateways` | `ERGatewayConnectionBitsInPerSecond`; `ERGatewayConnectionBitsOutPerSecond` | Average < 1 | PT5M/PT5M | Sev0 | No |
| `Microsoft.Network/expressRouteGateways` | `ExpressRouteGatewayCpuUtilization` | Average > 80 | PT5M/PT1M | Sev1 | Yes |
| `Microsoft.Network/expressRouteGateways` | `ExpressRouteGatewayActiveFlows` | Average > 200000 | PT5M/PT5M | Sev0 | Yes |
| `Microsoft.Network/expressRoutePorts` | `PortBitsInPerSecond`; `PortBitsOutPerSecond` | Average < 1 | PT5M/PT1M | Sev0 | No |
| `Microsoft.Network/expressRoutePorts` | `LineProtocol` | Average < 0.9 | PT5M/PT1M | Sev0 | No |
| `Microsoft.Network/expressRoutePorts` | `RxLightLevel` high; `TxLightLevel` high | Average > 0 | PT5M/PT1M | Sev1 | No |
| `Microsoft.Network/expressRoutePorts` | `RxLightLevel` low; `TxLightLevel` low | Average < -10 | PT5M/PT1M | Sev1 | No |
| `Microsoft.Network/frontdoors` | `BackendHealthPercentage` | Average < 90 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/frontdoors` | `BackendRequestLatency` | Average, dynamic > | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/loadBalancers` | `VipAvailability`; `GlobalBackendAvailability` | Average < 90 | PT5M/PT1M | Sev0 | Yes |
| `Microsoft.Network/loadBalancers` | `DipAvailability` | Average < 90 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/loadBalancers` | `UsedSNATPorts` | Average > 900 | PT5M/PT1M | Sev1 | Yes |
| `Microsoft.Network/p2sVpnGateways` | `P2SBandwidth` | Average > 1 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/p2sVpnGateways` | `P2SConnectionCount`; `UserVpnRouteCount` | Sum > 1 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/privateDnsZones` | `VirtualNetworkLinkCapacityUtilization`; `RecordSetCapacityUtilization`; `VirtualNetworkWithRegistrationCapacityUtilization` | Maximum >= 80 | PT1H/PT1H | Sev2 | Yes |
| `Microsoft.Network/privateDnsZones` | `QueryVolume` | Total >= 500 | PT1H/PT1H | Sev4 | No |
| `Microsoft.Network/publicIPAddresses` | `bytesinddos` | Maximum > 8000000 | PT5M/PT5M | Sev4 | No |
| `Microsoft.Network/publicIPAddresses` | `ifunderddosattack` | Maximum > 0 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/publicIPAddresses` | `PacketsInDDoS` | Total >= 40000 | PT5M/PT5M | Sev4 | No |
| `Microsoft.Network/publicIPAddresses` | `VipAvailability` | Average < 90 | PT5M/PT1M | Sev1 | Yes |
| `Microsoft.Network/trafficManagerProfiles` | `ProbeAgentCurrentEndpointStateByProfileResourceId` | Average < 0.9 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Network/virtualHubs` | `bgppeerstatus` | Maximum < 1 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/virtualHubs` | `CountOfRoutesAdvertisedToPeer`; `CountOfRoutesLearnedFromPeer` | Maximum > 1000 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/virtualHubs` | `RoutingInfrastructureUnits` | Maximum > 30 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/virtualHubs` | `SpokeVMUtilization` | Maximum > 90 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/virtualHubs` | `VirtualHubDataProcessed` | Maximum > 5000 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/virtualNetworkGateways` | `TunnelAverageBandwidth`; `ExpressRouteGatewayBitsPerSecond` | Average < 1 | PT5M/PT1M | Sev0 | Yes |
| `Microsoft.Network/virtualNetworkGateways` | `TunnelEgressBytes`; `TunnelIngressBytes` | Average < 1 | PT5M/PT5M | Sev0 | No |
| `Microsoft.Network/virtualNetworkGateways` | `TunnelEgressPacketDropCount` | Dynamic > | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Network/virtualNetworkGateways` | `TunnelEgressPacketDropTSMismatch`; `TunnelIngressPacketDropCount`; `TunnelIngressPacketDropTSMismatch` | Dynamic > | PT5M/PT5M | Sev3 | Yes |
| `Microsoft.Network/virtualNetworkGateways` | `ExpressRouteGatewayCpuUtilization` | Average > 80 | PT5M/PT1M | Sev3 | Yes |
| `Microsoft.Network/virtualNetworks` | `ifunderddosattack` | Maximum > 1 | PT5M/PT1M | Sev1 | Yes |
| `Microsoft.Network/vpnGateways` | `tunnelaveragebandwidth` | Average < 1 | PT5M/PT5M | Sev0 | Yes |
| `Microsoft.Network/vpnGateways` | `bgppeerstatus` | Total < 1 | PT5M/PT5M | Sev3 | Yes |
| `Microsoft.Network/vpnGateways` | `tunnelegressbytes`; `tunnelingressbytes` | Average < 1 | PT5M/PT5M | Sev0 | No |
| `Microsoft.Network/vpnGateways` | `TunnelEgressPacketDropCount`; `TunnelEgressPacketDropTSMismatch`; `TunnelIngressPacketDropCount`; `TunnelIngressPacketDropTSMismatch` | Dynamic > | PT5M/PT5M | Sev3 | Yes |
| `Microsoft.Storage/storageAccounts` | `Availability` | Average < 90 | PT5M/PT5M | Sev1 | Yes |
| `Microsoft.Web/serverFarms` | `CpuPercentage` | Average > 90 | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Web/serverFarms` | `DiskQueueLength`; `HttpQueueLength` | Average, dynamic > | PT5M/PT1M | Sev2 | Yes |
| `Microsoft.Web/serverFarms` | `MemoryPercentage` | Average > 85 | PT5M/PT1M | Sev2 | Yes |

Metric source paths are `docs/content/patterns/alz/getting-started/Metric-Alerts-Table.md:8-93` and the effective overrides in `patterns/alz/alzArm.param.json` at the pinned commit.

### Per-service activity and platform-health catalog

| Resource type | Alert | Kind and condition | Severity | Default |
|---------------|-------|--------------------|----------|---------|
| `Microsoft.Insights/components` | `ActivityAppInsightsDelete` | Activity Log delete | Verbose | Alert state No |
| `Microsoft.KeyVault/managedHSMs` | `ActivityManagedHSMDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.KeyVault/vaults` | `ActivityKeyVaultDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.Network/azureFirewalls` | `ActivityAzureFirewallDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.Network/networkSecurityGroups` | `ActivityNSGDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.Network/routeTables` | `ActivityUDRDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.Network/routeTables` | `ActivityUDRRoutesDelete` | Activity Log route delete | Verbose | Yes |
| `Microsoft.Network/routeTables` | `ActivityUDRUpdate` | Activity Log route update | Verbose | Yes |
| `Microsoft.Network/vpnGateways` | `ActivityVPNGatewayDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.OperationalInsights/workspaces` | `ActivityLAWorkspaceDelete` | Activity Log delete | Verbose | Yes |
| `Microsoft.OperationalInsights/workspaces` | `ActivityLAWorkspaceRegenKey` | Activity Log key regeneration | Verbose | Yes |
| `Microsoft.Storage/storageAccounts` | `Activity Log Storage Account Delete` | Activity Log delete | Verbose | Yes |
| `Microsoft.Resources/subscriptions` | `ResourceHealthUnhealthyAlert` | Resource Health, PlatformInitiated/UserInitiated, Degraded/Unavailable | Activity Log | Yes |
| `Microsoft.Resources/subscriptions` | `ServiceHealthSubscriptionAlertRule` | Service Issues, Planned Maintenance, Health Advisories, Security Advisories | Activity Log | Yes |

Activity source path: `docs/content/patterns/alz/getting-started/Activity-Log-Alerts-Table.md:8-24`. Current health-policy sources: `services/Resources/subscriptions/Deploy-ActivityLog-ResourceHealth-UnHealthly-Alert.json:1-250` and `patterns/alz/policySetDefinitions/Deploy-ResourceAndServiceHealth-Alerts.json:60-230`.

### Per-service log-search catalog

| Resource type | Rules | Period/frequency | Severity | Default |
|---------------|-------|------------------|----------|---------|
| `Microsoft.Compute/virtualMachines` | 11: Heartbeat; Network In/Out; OS disk read/write latency and free space; CPU; memory; data-disk free space and read/write latency | Heartbeat PT6H/PT5M; all others PT15M/PT5M | Heartbeat Sev1; others Sev2 | All Yes |
| `Microsoft.Compute/virtualMachineScaleSets` | The same 11 subjects, covering Flexible instances and Uniform VMSS | Same as VM | Same as VM | All Yes |
| `Microsoft.HybridCompute/machines` | The same 11 subjects plus Disconnected | Shared rules same as VM; Disconnected P1D/PT10M | Shared rules same as VM; Disconnected Sev1 | All Yes |
| `Microsoft.Insights/components` | `ApplicationInsightsThrottlingLimitReached` | PT5M/PT5M | Sev1 | Policy DINE Yes; alert state No |
| `Microsoft.OperationalInsights/workspaces` | `DailyCapLimitReachedAlert` | PT5M/PT5M | Sev1 | Yes |

The source summary is `docs/content/patterns/alz/getting-started/Log-Search-Alerts-Table.md:8-43`; exact Kusto and source files follow.

## Log Analytics and log-search (Kusto) alerts

AMBA stores these queries as single-line ARM `format()` strings. The Kusto below is reflowed with one operator per line for readability and markdown line-length compliance. Operator order, predicates, thresholds, tag names, and field names are unchanged. The exact single-line literal is at each cited repository source path.

The 36 log-search rules are 11 VM, 11 VMSS, 12 Hybrid Compute, one Application Insights, and one Log Analytics workspace rule. Shared query bodies are shown once, with the resource-type substitution and VMSS wrapper made explicit.

### Shared VM prefix

Use this prefix for `Microsoft.Compute/virtualMachines` rules:

```kusto
let policyThresholdString = "{threshold}";
let resourceTagging = (
    arg("").resources
    | where type =~ "Microsoft.Compute/virtualMachines"
    | where isempty(properties.virtualMachineScaleSet)
    | where tags.["MonitorDisable"] !in~ ("true","Test","Dev","Sandbox")
    | project _ResourceId = tolower(id), resourceTags = tags
);
```

### Shared Hybrid Compute prefix

Use this prefix for `Microsoft.HybridCompute/machines` rules:

```kusto
let policyThresholdString = "{threshold}";
let resourceTagging = (
    arg("").resources
    | where type =~ "Microsoft.HybridCompute/machines"
    | where tags.["MonitorDisable"] !in~ ("true","Test","Dev","Sandbox")
    | project _ResourceId = tolower(id), resourceTags = tags
);
```

In each shared body below, substitute `Microsoft.Compute/virtualMachines` or `Microsoft.HybridCompute/machines` for `{resource-filter}`. Each is enabled for VM and Hybrid Compute. The corresponding VMSS rules are also enabled and use the wrapper documented after the shared bodies.

### DataDiskReadLatency Kusto

Threshold 30 ms; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-DataDiskReadLatency-Alert.json:230-300`, `services/HybridCompute/machines/Deploy-Hybrid-VM-DataDiskReadLatency-Alert.json:230-300`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-DataDiskReadLatency-Alert.json:245-320`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "LogicalDisk" and Name == "ReadLatencyMs"
| extend Disk=tostring(todynamic(Tags)["vm.azm.ms/mountId"])
| where Disk !in ("C:", "/")
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, Disk
| lookup kind=inner (resourceTagging) on _ResourceId
| extend excludedLogicalVolumes = iif(isnotempty(resourceTags.["_amba-ExcludedLogicalVolumes-ReadLatency_"]),resourceTags.["_amba-ExcludedLogicalVolumes-ReadLatency_"], "No logical volumes excluded")
| where excludedLogicalVolumes !has Disk
| extend newThresholdString = tostring(resourceTags.["_amba-ReadLatencyMs-Data-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Disk, AggregatedValue, appliedThreshold, excludedLogicalVolumes
```

### DataDiskSpace Kusto

Threshold 10%; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-DataDiskSpace-Alert.json:230-300`, `services/HybridCompute/machines/Deploy-Hybrid-VM-DataDiskSpace-Alert.json:230-300`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-DataDiskSpace-Alert.json:245-320`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "LogicalDisk" and Name == "FreeSpacePercentage"
| extend Disk=tostring(todynamic(Tags)["vm.azm.ms/mountId"])
| where Disk !in ("C:", "/")
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, Disk
| lookup kind=inner (resourceTagging) on _ResourceId
| extend excludedLogicalVolumes = iif(isnotempty(resourceTags.["_amba-ExcludedLogicalVolumes-DiskSpace_"]),resourceTags.["_amba-ExcludedLogicalVolumes-DiskSpace_"], "No logical volumes excluded")
| where excludedLogicalVolumes !has Disk
| extend newThresholdString = tostring(resourceTags.["_amba-FreeSpacePercentage-Data-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue < appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Disk, AggregatedValue, appliedThreshold, excludedLogicalVolumes
```

### DataDiskWriteLatency Kusto

Threshold 30 ms; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-DataDiskWriteLatency-Alert.json:230-300`, `services/HybridCompute/machines/Deploy-Hybrid-VM-DataDiskWriteLatency-Alert.json:230-300`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-DataDiskWriteLatency-Alert.json:245-320`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "LogicalDisk" and Name == "WriteLatencyMs"
| extend Disk=tostring(todynamic(Tags)["vm.azm.ms/mountId"])
| where Disk !in ("C:", "/")
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, Disk
| lookup kind=inner (resourceTagging) on _ResourceId
| extend excludedLogicalVolumes = iif(isnotempty(resourceTags.["_amba-ExcludedLogicalVolumes-WriteLatency_"]),resourceTags.["_amba-ExcludedLogicalVolumes-WriteLatency_"], "No logical volumes excluded")
| where excludedLogicalVolumes !has Disk
| extend newThresholdString = tostring(resourceTags.["_amba-WriteLatencyMs-Data-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Disk, AggregatedValue, appliedThreshold, excludedLogicalVolumes
```

### Heartbeat Kusto

Threshold 10 minutes; period/frequency PT6H/PT5M; Sev1; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-HeartBeat-Alert.json:230-295`, `services/HybridCompute/machines/Deploy-Hybrid-VM-HeartBeat-Alert.json:230-295`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-HeartBeat-Alert.json:245-315`.

```kusto
Heartbeat
| where _ResourceId has "{resource-filter}"
| summarize TimeGenerated=max(TimeGenerated) by Computer, _ResourceId
| extend Duration = datetime_diff("minute",now(),TimeGenerated)
| lookup kind=inner (resourceTagging) on _ResourceId
| extend newThresholdString = tostring(resourceTags.["_amba-Heartbeat-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where Duration > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Duration, appliedThreshold
```

### NetworkIn Kusto

Threshold 10000000 bytes per second; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-NetworkIn-Alert.json:230-295`, `services/HybridCompute/machines/Deploy-Hybrid-VM-NetworkIn-Alert.json:230-295`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-NetworkIn-Alert.json:245-315`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "Network" and Name == "ReadBytesPerSecond"
| extend NetworkInterface=tostring(todynamic(Tags)["vm.azm.ms/networkDeviceId"])
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, NetworkInterface
| lookup kind=inner (resourceTagging) on _ResourceId
| extend newThresholdString = tostring(resourceTags.["_amba-ReadBytesPerSecond-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, NetworkInterface, AggregatedValue, appliedThreshold
```

### NetworkOut Kusto

Threshold 10000000 bytes per second; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-NetworkOut-Alert.json:230-295`, `services/HybridCompute/machines/Deploy-Hybrid-VM-NetworkOut-Alert.json:230-295`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-NetworkOut-Alert.json:245-315`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "Network" and Name == "WriteBytesPerSecond"
| extend NetworkInterface=tostring(todynamic(Tags)["vm.azm.ms/networkDeviceId"])
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, NetworkInterface
| lookup kind=inner (resourceTagging) on _ResourceId
| extend newThresholdString = tostring(resourceTags.["_amba-WriteBytesPerSecond-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, NetworkInterface, AggregatedValue, appliedThreshold
```

### OSDiskReadLatency Kusto

Threshold 30 ms; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-OSDiskReadLatency-Alert.json:230-300`, `services/HybridCompute/machines/Deploy-Hybrid-VM-OSDiskReadLatency-Alert.json:230-300`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-OSDiskReadLatency-Alert.json:245-320`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "LogicalDisk" and Name == "ReadLatencyMs"
| extend Disk=tostring(todynamic(Tags)["vm.azm.ms/mountId"])
| where Disk in ("C:", "/")
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, Disk
| lookup kind=inner (resourceTagging) on _ResourceId
| extend excludedLogicalVolumes = iif(isnotempty(resourceTags.["_amba-ExcludedLogicalVolumes-ReadLatency_"]),resourceTags.["_amba-ExcludedLogicalVolumes-ReadLatency_"], "No logical volumes excluded")
| where excludedLogicalVolumes !has Disk
| extend newThresholdString = tostring(resourceTags.["_amba-ReadLatencyMs-OS-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Disk, AggregatedValue, appliedThreshold, excludedLogicalVolumes
```

### OSDiskSpace Kusto

Threshold 10%; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-OSDiskSpace-Alert.json:230-300`, `services/HybridCompute/machines/Deploy-Hybrid-VM-OSDiskSpace-Alert.json:230-300`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-OSDiskSpace-Alert.json:245-320`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "LogicalDisk" and Name == "FreeSpacePercentage"
| extend Disk=tostring(todynamic(Tags)["vm.azm.ms/mountId"])
| where Disk in ("C:", "/")
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, Disk
| lookup kind=inner (resourceTagging) on _ResourceId
| extend excludedLogicalVolumes = iif(isnotempty(resourceTags.["_amba-ExcludedLogicalVolumes-DiskSpace_"]),resourceTags.["_amba-ExcludedLogicalVolumes-DiskSpace_"], "No logical volumes excluded")
| where excludedLogicalVolumes !has Disk
| extend newThresholdString = tostring(resourceTags.["_amba-FreeSpacePercentage-OS-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue < appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Disk, AggregatedValue, appliedThreshold, excludedLogicalVolumes
```

### OSDiskWriteLatency Kusto

Threshold 30 ms; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-OSDiskWriteLatency-Alert.json:230-300`, `services/HybridCompute/machines/Deploy-Hybrid-VM-OSDiskWriteLatency-Alert.json:230-300`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-OSDiskWriteLatency-Alert.json:245-320`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "LogicalDisk" and Name == "WriteLatencyMs"
| extend Disk=tostring(todynamic(Tags)["vm.azm.ms/mountId"])
| where Disk in ("C:", "/")
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId, Disk
| lookup kind=inner (resourceTagging) on _ResourceId
| extend excludedLogicalVolumes = iif(isnotempty(resourceTags.["_amba-ExcludedLogicalVolumes-WriteLatency_"]),resourceTags.["_amba-ExcludedLogicalVolumes-WriteLatency_"], "No logical volumes excluded")
| where excludedLogicalVolumes !has Disk
| extend newThresholdString = tostring(resourceTags.["_amba-WriteLatencyMs-OS-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, Disk, AggregatedValue, appliedThreshold, excludedLogicalVolumes
```

### CPU Kusto

Threshold 85%; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-PercentCPU-Alert.json:230-295`, `services/HybridCompute/machines/Deploy-Hybrid-VM-PercentCPU-Alert.json:230-295`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-PercentCPU-Alert.json:245-315`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "Processor" and Name == "UtilizationPercentage"
| summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId
| lookup kind=inner (resourceTagging) on _ResourceId
| extend newThresholdString = tostring(resourceTags.["_amba-UtilizationPercentage-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue > appliedThreshold
| project TimeGenerated, Computer, _ResourceId, AggregatedValue, appliedThreshold
```

### Memory Kusto

Threshold 10% available memory; period/frequency PT15M/PT5M; Sev2; enabled for VM, Hybrid Compute, and VMSS. Sources: `services/Compute/virtualMachines/Deploy-VM-PercentMemory-Alert.json:230-295`, `services/HybridCompute/machines/Deploy-Hybrid-VM-PercentMemory-Alert.json:230-295`, and `services/Compute/virtualMachineScaleSets/Deploy-VMSS-PercentMemory-Alert.json:245-315`.

```kusto
InsightsMetrics
| where _ResourceId has "{resource-filter}"
| where Origin == "vm.azm.ms"
| where Namespace == "Memory" and Name == "AvailableMB"
| extend TotalMemory = toreal(todynamic(Tags)["vm.azm.ms/memorySizeMB"])
| extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0
| summarize AggregatedValue = avg(AvailableMemoryPercentage) by bin(TimeGenerated, 15m), Computer, _ResourceId
| lookup kind=inner (resourceTagging) on _ResourceId
| extend newThresholdString = tostring(resourceTags.["_amba-AvailableMemoryPercentage-threshold-Override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where AggregatedValue < appliedThreshold
| project TimeGenerated, Computer, _ResourceId, AggregatedValue, appliedThreshold
```

### VMSS Flexible and Uniform wrapper

Each of the 11 VMSS policies wraps the matching shared body in Flexible and Uniform branches. Thresholds, windows, frequencies, severities, and enabled states are identical to the VM rules. The body and override tail stay in the same order.

```kusto
let policyThresholdString = "{threshold}";
let resourceTagging = (
    arg("").resources
    | where (type =~ "Microsoft.Compute/virtualMachines" and not(isempty(properties.virtualMachineScaleSet))) or (type =~ "microsoft.compute/virtualmachinescalesets" and properties.orchestrationMode =~ "uniform")
    | where tags.["MonitorDisable"] !in~ ("true","Test","Dev","Sandbox")
    | project _ResourceId = tolower(id), resourceTags = tags
);
let vmssFlexible = (
    {subject-query}
    | lookup kind=inner (resourceTagging) on _ResourceId
);
let vmssUniform = (
    {subject-query-with: _ResourceId matches regex "microsoft.compute/virtualmachinescalesets/.*/"}
    | extend reducedResourceId = tostring(split(_ResourceId, "/virtualmachines/")[0])
    | lookup kind=inner (resourceTagging) on $left.reducedResourceId == $right._ResourceId
);
union kind=outer vmssFlexible, vmssUniform
| project-away reducedResourceId
| {same override/comparison/project tail shown above}
```

Exact VMSS source paths are:

- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-DataDiskReadLatency-Alert.json:245-320`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-DataDiskSpace-Alert.json:245-320`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-DataDiskWriteLatency-Alert.json:245-320`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-HeartBeat-Alert.json:245-315`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-NetworkIn-Alert.json:245-315`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-NetworkOut-Alert.json:245-315`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-OSDiskReadLatency-Alert.json:245-320`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-OSDiskSpace-Alert.json:245-320`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-OSDiskWriteLatency-Alert.json:245-320`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-PercentCPU-Alert.json:245-315`
- `services/Compute/virtualMachineScaleSets/Deploy-VMSS-PercentMemory-Alert.json:245-315`

### HybridVMDisconnectedAlert Kusto

Scheduled-query Count > 0; disconnect threshold 10 minutes; period/frequency P1D/PT10M; Sev1; enabled. Source: `services/HybridCompute/machines/Deploy-Hybrid-VM-Disconnected-Alert.json:220-305`.

```kusto
let policyThresholdString = "10m";
arg("").resources
| where type == "microsoft.hybridcompute/machines"
| where tostring(tags.["MonitorDisable"]) !in~ ("true","Test","Dev","Sandbox")
| where tostring(properties.status) == "Disconnected"
| extend lastContactedDate = todatetime(properties.lastStatusChange)
| where lastContactedDate <= ago(totimespan(policyThresholdString))
| extend status = tostring(properties.status)
| project id, Computer=name, status, lastContactedDate
```

### ApplicationInsightsThrottlingLimitReached Kusto

Query-side threshold 32000 and scheduled-query Count > 0; period/frequency PT5M/PT5M; Sev1. The policy effect is DINE, but the deployed alert state defaults to disabled. Source: `services/Insights/components/Deploy-AppInsightsThrottlingLimit-Alert.json:210-330`.

The concrete Application Insights resource ID is supplied through `parameters('resourceId')` during DINE deployment, so the placeholder below is environment-specific.

```kusto
let policyThresholdString = "32000";
let resourceTagging = (
    arg("").resources
    | where type =~ "Microsoft.Insights/components"
    | where tags.["MonitorDisable"] !in~ ("true","Test","Dev","Sandbox")
    | project _ResourceId = tolower(id), resourceTags = tags, name
);
AppSystemEvents
| where _ResourceId =~ "<the Application Insights resource ID supplied by the DINE deployment>"
| summarize numOfEvents = sum(toint(Measurements["BillingTelemetryCount"])) by _ResourceId, Type, bin(TimeGenerated, 1h)
| lookup kind=inner (resourceTagging) on _ResourceId
| extend newThresholdString = tostring(resourceTags.["_amba-Throttling-threshold-override_"])
| extend appliedThreshold = iif(isempty(newThresholdString), toint(policyThresholdString), toint(newThresholdString))
| where numOfEvents > appliedThreshold
| project TimeGenerated, _ResourceId, name, numOfEvents
```

### LAWorkspaceDailyCapLimitReached Kusto

Scheduled-query Count > 0; period/frequency PT5M/PT5M; Sev1; enabled. Source: `services/OperationalInsights/workspaces/Deploy-LAWorkspace-DailyCapLimitReached-Alert.json:220-350`.

```kusto
let resourceTagging = (
    arg("").resources
    | where type =~ "Microsoft.OperationalInsights/workspaces"
    | where tags.["MonitorDisable"] !in~ ("true","Test","Dev","Sandbox")
    | project id, resourceTags = tags, customerId = tostring(properties.customerId), workspaceName = tostring(name)
);
Operation
| where OperationCategory == "Data Collection Status"
| where Detail has_any("RespectQuota", "OverQuota")
| summarize arg_max(TimeGenerated, *) by TenantId
| where Detail has "OverQuota"
| lookup kind=inner (resourceTagging) on $left.TenantId == $right.customerId
| project TimeGenerated, id, workspaceName, workspaceId = TenantId, Detail
```

## How to verify or regenerate this document

1. Check out the pinned AMBA commit.
2. Read `patterns/alz/alzArm.param.json`, `patterns/alz/policySetDefinitions/*.json`, and `patterns/alz/policyAssignments/*.json` to determine initiative membership and effective default state.
3. Trace each policy reference into `patterns/alz/policyDefinitions/*.json` and `services/**/Deploy-*.json`. Count unique non-deprecated alert rules by type.
4. Read `services/**/alerts.yaml` and generated tables only as secondary aids. Resolve disagreements in favor of the effective ALZ parameter file and policy-set definitions.
5. Re-extract each scheduled-query literal from its deployment policy, unescape only the ARM string representation, and compare the reflowed Kusto after stripping whitespace.
6. Re-run markdown lint, the 900-character line check, URL probes, catalog count assertions, and local-link validation.

## Limitations of this document

- It is a static snapshot of one AMBA commit and will become stale.
- It catalogs current non-deprecated ALZ initiative rules, not every alert recommendation in the generic AMBA service catalog.
- Default enablement does not prove successful deployment, remediation, query execution, action-group routing, or operational suitability.
- Threshold suitability is workload-specific. Inclusion here is not a recommendation to use a value unchanged.
- Recovery Services settings are described but not counted as alert rules because the repository does not define standalone rule names, thresholds, windows, and severities for them.
- The CloudHealth modules are preview and have not been proven here through live Azure policy evaluation or remediation.
