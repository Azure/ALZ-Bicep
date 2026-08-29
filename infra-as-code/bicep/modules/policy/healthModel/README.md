# Module: CloudHealth Platform and Application Health Model Policies (Preview, experimental)

These modules deploy preview Microsoft CloudHealth health-model policies for Azure Landing Zones.

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

At Platform or Landing Zones scope, the remediation identity can write and delete role
assignments in descendant subscriptions. The CloudHealth path does not use Managed Identity
Operator.

## Native ALZ default assignments

The ALZ default-assignment module enables both CloudHealth assignments by default:

| Parameter | Default | Assignment scope |
| --- | --- | --- |
| `parPlatformHealthModelPolicyAssignmentEnable` | `true` | Platform management group |
| `parApplicationHealthModelPolicyAssignmentEnable` | `true` | Landing Zones management group |

Disable either model with its bool parameter or by adding the assignment name to `parExcludedPolicyAssignments`.

Step 2, `customPolicyDefinitions.bicep`, deploys the CloudHealth policy definitions. Step 8
assigns them.

## Parameters

- [Management-group definition parameters](generateddocs/healthModelPolicyDefinitions.bicep.md)
- [Shared topology parameters](generateddocs/healthModelTopology.bicep.md)

The default-assignment path does not require a discovery user-assigned identity, discovery
principal ID, or per-domain subscription IDs. The topology sets each domain subscription
parameter to `subscription().subscriptionId` in the evaluated subscription.

Advanced overrides remain available through resource-type arrays and `parDomainOverrides`.

## Region and preview boundary

`Microsoft.CloudHealth` is preview and AzureCloud-only in this module. Query the current provider locations before deployment:

```bash
az provider show --namespace Microsoft.CloudHealth \
  --query "resourceTypes[?resourceType=='healthmodels'].locations[]" \
  --output table
```

Set the location parameters to a returned region. Unsupported regions or an unregistered provider fail remediation.

Compilation validates the policy and embedded template shape. Use a live policy scan and
remediation to validate preview resource-provider behavior.

## Embedded topology artifacts

The policies embed:

- `policy_healthModelPlatformTopology.json`
- `policy_healthModelApplicationTopology.json`

After changing either topology `.bicep`, rebuild its paired artifact:

```bash
az bicep build --file infra-as-code/bicep/modules/policy/healthModel/healthModelPlatformTopology.bicep --outfile infra-as-code/bicep/modules/policy/healthModel/policy_healthModelPlatformTopology.json
az bicep build --file infra-as-code/bicep/modules/policy/healthModel/healthModelApplicationTopology.bicep --outfile infra-as-code/bicep/modules/policy/healthModel/policy_healthModelApplicationTopology.json
```

The Bicep build workflow verifies artifact freshness, escaping, and literal `copy` blocks.

## Policy deployment

The ALZ flow assigns both models through policy:

- Platform model assignment targets the Platform management group.
- Application model assignment targets the Landing Zones management group.
