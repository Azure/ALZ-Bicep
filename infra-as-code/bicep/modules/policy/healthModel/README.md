# Module: CloudHealth Platform and Application Health Model Policies (Preview, experimental)

These modules provide preview Microsoft CloudHealth health-model policies for Azure Landing Zones.

- `healthModelPolicy.bicep` deploys the platform model policy at subscription scope.
- `applicationHealthModelPolicy.bicep` deploys the application landing-zone model policy at subscription scope.
- `healthModelPolicyDefinitions.bicep` deploys the matching management-group policy definitions used by ALZ default assignments.
- `healthModelPlatformTopology.bicep` and `healthModelApplicationTopology.bicep` are the topology templates embedded by the policies.

For concepts, see [Health Models in Azure Landing Zones](../../../../../docs/wiki/HealthModels.md).

## What deploys

Each policy remediation creates, per evaluated subscription:

- the configured target resource group when it does not exist;
- one `Microsoft.CloudHealth/healthmodels` resource with `identity.type = SystemAssigned`;
- one managed-identity authentication setting with `managedIdentityName = SystemAssigned`;
- domain grouping entities, discovery rules, and relationships for the platform or application taxonomy;
- a Reader assignment for the health model's system-assigned identity at the evaluated subscription.

The policy-assignment managed identity needs these roles at assignment scope:

- Contributor (`b24988ac-6180-42a0-ab88-20f7382dd24c`) to create the resource group and CloudHealth resources.
- Role Based Access Control Administrator (`f58310d9-a9f6-439a-9e8d-f62e7b41a168`) to create the Reader assignment for the health model identity.

This is a significant escalation. Over Platform or Landing Zones descendants, the remediation identity can write and delete role assignments. Managed Identity Operator is not used in the CloudHealth path.

## Native ALZ default assignments

The ALZ default-assignment module enables both CloudHealth assignments by default:

| Parameter | Default | Assignment scope |
| --- | --- | --- |
| `parPlatformHealthModelPolicyAssignmentEnable` | `true` | Platform management group |
| `parApplicationHealthModelPolicyAssignmentEnable` | `true` | Landing Zones management group |

Disable either model with its bool parameter or by adding the assignment name to `parExcludedPolicyAssignments`.

The normal step 2 `customPolicyDefinitions.bicep` deployment now deploys the CloudHealth policy definitions. The step 8 default policy-assignment deployment only assigns them.

## Parameters

- [Platform policy parameters](generateddocs/healthModelPolicy.bicep.md)
- [Application policy parameters](generateddocs/applicationHealthModelPolicy.bicep.md)
- [Management-group definition parameters](generateddocs/healthModelPolicyDefinitions.bicep.md)
- [Shared topology parameters](generateddocs/healthModelTopology.bicep.md)

The native default-assignment path does not require a discovery user-assigned identity, discovery principal ID, or per-domain subscription IDs. The topology defaults each domain subscription parameter to `subscription().subscriptionId` inside the evaluated subscription deployment.

Advanced overrides remain available through resource-type arrays and `parDomainOverrides`.

## Region and preview boundary

`Microsoft.CloudHealth` is preview and AzureCloud-only in this module. Query the current provider locations before deployment:

```bash
az provider show --namespace Microsoft.CloudHealth \
  --query "resourceTypes[?resourceType=='healthmodels'].locations[]" \
  --output table
```

Set the location parameters to a returned region. Unsupported regions or an unregistered provider fail remediation.

Compilation proves the authored policy and embedded template shape only. A live policy scan and remediation are still required to prove preview-RP runtime behavior.

## Embedded topology artifacts

The policies embed:

- `policy_healthModelPlatformTopology.json`
- `policy_healthModelApplicationTopology.json`

After changing either topology `.bicep`, rebuild its paired artifact:

```bash
az bicep build --file infra-as-code/bicep/modules/policy/healthModel/healthModelPlatformTopology.bicep --outfile infra-as-code/bicep/modules/policy/healthModel/policy_healthModelPlatformTopology.json
az bicep build --file infra-as-code/bicep/modules/policy/healthModel/healthModelApplicationTopology.bicep --outfile infra-as-code/bicep/modules/policy/healthModel/policy_healthModelApplicationTopology.json
```

The Bicep build workflow verifies artifact freshness, policy-rule parity, escaping, and literal `copy` blocks.

## Standalone subscription entrypoints

Deploy the platform policy with minimum parameters:

```bash
az deployment sub create \
  --name alz-cloudhealth \
  --location swedencentral \
  --template-file infra-as-code/bicep/modules/policy/healthModel/healthModelPolicy.bicep \
  --parameters @infra-as-code/bicep/modules/policy/healthModel/parameters/healthModelPolicy.parameters.min.json
```

Deploy the application policy with `applicationHealthModelPolicy.bicep` and its matching minimum parameter file.

`parDeployHealthModel` maps `true` to `DeployIfNotExists` and `false` to `Disabled`. Setting it to `false` pauses remediation while keeping the policy assignment and remediation RBAC in place.

## Policy default versus standalone deployment

Both models are intentionally policy-assigned in the native ALZ flow:

- Platform model assignment targets the Platform management group.
- Application model assignment targets the Landing Zones management group.

Keep that split for the default contract and use standalone deployments for direct operator workflows, testing, and rapid iteration. Treating one model as policy-driven and the other as deployment-only creates an uneven operating model and drops automatic policy remediation from one side.

## Live deployment and visualization proof (2026-08-14)

This run deployed both topologies to `rg-hm-docs-20260814172505` in `swedencentral`:

- Platform model: `alz-platform-docs-20260814172505` (`Succeeded`, 22 entities, 21 relationships)
- Application model: `alz-application-docs-20260814172505` (`Succeeded`, 21 entities, 17 relationships)

The application topology uses an internal domain entity name `aiml` (display name `AI`) to satisfy the current RP entity-name pattern requirement.

Known preview limitation from this run: the outer application deployment operation did not consistently converge to clean terminal success. One retry failed at nested deployment with `EntityCreationError` (`Internal server error on entity creation. Please try again later.`), while the model resource itself was created and queryable. Use model/resource reads plus entity/relationship reads as the practical evidence boundary until RP convergence behavior stabilizes.

Reproduction commands:

```bash
az deployment group create --resource-group <rg> --name <platform-deploy> \
  --template-file infra-as-code/bicep/modules/policy/healthModel/healthModelPlatformTopology.bicep \
  --parameters parHealthModelName=<platform-model-name> parLocation=swedencentral

az deployment group create --resource-group <rg> --name <application-deploy> \
  --template-file infra-as-code/bicep/modules/policy/healthModel/healthModelApplicationTopology.bicep \
  --parameters parHealthModelName=<application-model-name> parLocation=swedencentral

az deployment group show --resource-group <rg> --name <application-deploy> --query properties.provisioningState -o tsv
az monitor health-models show --resource-group <rg> --name <model-name>
az monitor health-models entity list --resource-group <rg> --health-model-name <model-name>
az monitor health-models relationship list --resource-group <rg> --health-model-name <model-name>
```

Live graph snapshots generated from `az monitor health-models entity list` plus `relationship list`:

![Live platform health model topology](./media/platform-healthmodel-live.png)

![Live application health model topology](./media/application-healthmodel-live.png)
