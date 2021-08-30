# Module:  Hub-Network

This module defines  spoke network based on the recommendations from the Azure Landing Zone Conceptual Architecture.  

Module deploys the following resources:
  * VNet
  * Subnets
  * UDR
  * Private DNS Link
  * Azure Key Vault
  * Recovery Services


## Parameters

The module requires the following inputs:

 Parameter | Type | Description | Requirement | Example
----------- | ---- | ----------- | ----------- | -------
parDdosEnabled | bool | Switch to enable deployment of distributed denial of service attacks service | None | true
parAzureFirewallEnabled | bool | Switch to enable deployment Azure Firewall | None | true 
parDdosPlanName | string | Name which will be associated with distributed denial of service protection plan | 1-80 char | MyDDosPlan
parTags | object | List of tags (Key Value Pairs) to be applied to resources | None | environment: 'development'
parHubNetworkAddressPrefix string | CIDR range for Hub Network| 2-50 | Hub
parHubNetworkPrefix | string | Name prefix for Virtual Network.  Prefix will be appended with the region.| 2-50 char | Hub
parAzureFirewallName | string |Name associate with Azure Firewall | 1-80 char | MyAzureFirewall
parHubRouteTableName | string | Name of route table to be associated with Hub Network | 1-80 char | HubRouteTable
parSubnets | array | Array of objects to providing for dynamic set of subnets | Must provide array of objects | { 
  ||||| name: 'frontend'
  ||||| ipAddressRange: '10.10.5.0/24'
||||| }
||||| {
  ||||| name: 'backend'
  ||||| ipAddressRange: '10.10.5.0/24' 
||||| }
## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------

## Deployment

In this example, the spoke resources will be deployed to the resource group specified.
We will take the default values and not pass any parameters.

> For the below examples we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
az deployment group hubnet create --resource-group HUB --template-file hub-network.bicep
```

![Example Deployment Output](media/hub-network-example-deployment-output.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicep-visualizer.png "Bicep Visualizer")