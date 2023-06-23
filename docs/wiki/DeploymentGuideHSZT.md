# Deploy Networking with Zero Trust network principles (Hub and Spoke)

This guide will review how to deploy the Azure landing zone Bicep accelerator with a jump start on Zero Trust Networking Principles for Azure landing zones.

For more information on Zero Trust security model and principles visit [Secure networks with Zero Trust](https://learn.microsoft.com/security/zero-trust/deploy/networks).

Deploying Zero Trust network principles with the Bicep deployment will involve setting certain module parameters to a value.  Some of these are already the default values, and do not need to be changed.  Others will need to be changed from their default values.

These parameters reside within the parameters folder of each module.  Below is a description of the parameters for each module.

## Hub Networking Parameters

In the [hubNetworking module parameters](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/hubNetworking/parameters/hubNetworking.parameters.all.json), use the following parameter values:

| Parameter value | Zero Trust Value | Default Value |
|---|---|---|
| `parDdosEnabled` | `true` | `true` |
| `parAzFirewallEnabled` | `true` | `true` |
| `parAzFirewallTier` | `Premium` | `Standard` |

This will deploy a DDoS Network Protection Plan to use to protect your networking resources from DDoS Attacks.  In addition, it will deploy an Azure Firewall with a Premium SKU that will enable you to set up TLS inspection in your environment.

## Default Policies

In the [Policy Assignment module parameters](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json), use the following parameter values:

| Parameter value | Zero Trust Value | Default Value |
|---|---|---|
| `parDisableAlzDefaultPolicies` | `false` | `false`|

This makes sure that the default policies are deployed, which contain policies related to Network Security Groups that will help you adopt Zero Trust for networking.

This is not needed for Zero Trust Telemetry.
