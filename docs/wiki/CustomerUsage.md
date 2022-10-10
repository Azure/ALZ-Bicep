<!-- markdownlint-disable -->
## Telemetry Tracking Using Customer Usage Attribution (PID)
<!-- markdownlint-restore -->

Microsoft can identify the deployments of the Azure Resource Manager and Bicep templates with the deployed Azure resources. Microsoft can correlate these resources used to support the deployments. Microsoft collects this information to provide the best experiences with their products and to operate their business. The telemetry is collected through [customer usage attribution](https://docs.microsoft.com/azure/marketplace/azure-partner-customer-usage-attribution). The data is collected and governed by Microsoft's privacy policies, located at the [trust center](https://www.microsoft.com/trustcenter).

To disable this tracking, we have included a parameter called `parTelemetryOptOut` to every bicep module in this repo with a simple boolean flag. The default value `false` which **does not** disable the telemetry. If you would like to disable this tracking, then simply set this value to `true` and this module will not be included in deployments and **therefore disables** the telemetry tracking.

If you are happy with leaving telemetry tracking enabled, no changes are required. Please do not edit the module name or value of the variable `varCuaid` in any module.

For example, in the managementGroups.bicep file, you will see the following:

```bicep
@description('Set Parameter to True to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = true
```

The default value is `false`, but by changing the parameter value `true` and saving this file, when you deploy this module either via PowerShell, Azure CLI, or as part of a pipeline the module deployment below will be ignored and therefore telemetry will not be tracked.

```bicep
// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdTenant.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
```

## Module PID Value Mapping

The following are the unique ID's (also known as PIDs) used in each of the modules:

| Module Name                     | PID                                  |
| ------------------------------- | ------------------------------------ |
| customRoleDefinitions           | 032d0904-3d50-45ef-a6c1-baa9d82e23ff |
| getManagementGroupName          | cff0ca56-5d8c-4594-bf79-5c046809b017 |
| hubNetworking                   | 2686e846-5fdc-4d4f-b533-16dcb09d6e6c |
| logging                         | f8087c67-cc41-46b2-994d-66e4b661860d |
| managementGroups                | 9b7965a0-d77c-41d6-85ef-ec3dfea4845b |
| mgDiagSettings                  | 5d17f1c2-f17b-4426-9712-0cd2652c4435 |
| policy-definitions              | 2b136786-9881-412e-84ba-f4c2822e1ac9 |
| policy-assignments              | 78001e36-9738-429c-a343-45cc84e8a527 |
| alzDefaultPolicyAssignments     | 98cef979-5a6b-403b-83c7-10c8f04ac9a2 |
| publicIp                        | 3f85b84c-6bad-4c42-86bf-11c233241c22 |
| resourceGroup                   | b6718c54-b49e-4748-a466-88e3d7c789c8 |
| roleAssignments                 | 59c2ac61-cd36-413b-b999-86a3e0d958fb |
| spokeNetworking                 | 0c428583-f2a1-4448-975c-2d6262fd193a |
| subscriptionPlacement           | 3dfa9e81-f0cf-4b25-858e-167937fd380b |
| virtualNetworkPeer              | ab8e3b12-b0fa-40aa-8630-e3f7699e2142 |
| vwanConnectivity                | 7f94f23b-7a59-4a5c-9a8d-2a253a566f61 |
| vnetPeeringVwan                 | 7b5e6db2-1e8c-4b01-8eee-e1830073a63d |
| privateDnsZones                 | 981733dd-3195-4fda-a4ee-605ab959edb6 |
| hubSpoke - Orchestration        | 50ad3b1a-f72c-4de4-8293-8a6399991beb |
| hubPeeredSpoke - Orchestration  | 8ea6f19a-d698-4c00-9afb-5c92d4766fd2 |
| SubPlacementAll - Orchestration | bb800623-86ff-4ab4-8901-93c2b70967ae |
| mgDiagSettingsAll - Orchestration | f49c8dfb-c0ce-4ee0-b316-5e4844474dd0 |
