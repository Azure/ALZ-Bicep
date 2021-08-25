# Module:  Hub-Network

This module defines custom hub network based on the recommendations from the Azure Landing Zone Conceptual Architecture.  

Module deploys the following resources:
  * VNet
  * Subnets
  * VPN Gateway/ExpressRoute Gateway
  * Azure Firewall or leverage a Resource Group with 3rd party NVA
  * NSGs
  * DDOS
  * Bastion 


## Parameters

The module requires the following inputs:

 Paramenter | Description | Requirement | Example
----------- | ----------- | ----------- | -------


## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------


## Deployment

In this example, the custom roles will be deployed to the `alz` management group (the intermediate root management group).

Input parameter file `custom-role-definitions.parameters.example.json` defines the assignable scope for the roles.  In this case, it will be the same management group (i.e. `alz`) as the one specified for the deployment operation.

> For the below examples we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
az deployment group hubnet create --resource-group HUB --template-file hub-network.bicep
```

![Example Deployment Output](media/example-deployment-output.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicep-visualizer.png "Bicep Visualizer")