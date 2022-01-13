
# Customer Usage Attribution

Microsoft can identify the deployments of the Azure Resource Manager and Bicep templates with the deployed Azure resources. Microsoft can correlate these resources used to support the deployments. Microsoft collects this information to provide the best experiences with their products and to operate their business. The telemetry is collected through [customer usage attribution](https://docs.microsoft.com/azure/marketplace/azure-partner-customer-usage-attribution). The data is collected and governed by Microsoft's privacy policies, located at the [trust center](https://www.microsoft.com/trustcentery).

To disable this tracking, we have included a parameter value to every module deployment which is a simple True/False. The default value is **"False"** which does not disable this telemetry. If you would like to disable this tracking, then simple set this value to **"True"** and this module will not be run.

```bicep
@description('Set Parameter to True to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false
```

The following are the unique ID's used in all the modules. 

| Module Name            | PID                                  |
| ---------------------- | ------------------------------------ |
| customRoleDefinitions  | 032d0904-3d50-45ef-a6c1-baa9d82e23ff |
| getManagementGroupName | cff0ca56-5d8c-4594-bf79-5c046809b017 |
| hubNetworking          | 2686e846-5fdc-4d4f-b533-16dcb09d6e6c |
| logging                | f8087c67-cc41-46b2-994d-66e4b661860d |
| managementGroups       | 9b7965a0-d77c-41d6-85ef-ec3dfea4845b |
| policy-definitions     | 2b136786-9881-412e-84ba-f4c2822e1ac9 |
| policy-assignments     | 78001e36-9738-429c-a343-45cc84e8a527 |
| publicIp               | 3f85b84c-6bad-4c42-86bf-11c233241c22 |
| resourceGroup          | b6718c54-b49e-4748-a466-88e3d7c789c8 |
| roleAssignments        | 59c2ac61-cd36-413b-b999-86a3e0d958fb |
| spokeNetworking        | 0c428583-f2a1-4448-975c-2d6262fd193a |
| subscriptionPlacement  | 3dfa9e81-f0cf-4b25-858e-167937fd380b |
| virtualNetworkPeer     | ab8e3b12-b0fa-40aa-8630-e3f7699e2142 |