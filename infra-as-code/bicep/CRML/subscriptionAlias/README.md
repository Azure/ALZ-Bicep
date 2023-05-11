# Module:  Subscription Alias

The Subscription Alias module deploys an Azure Subscription into an existing billing scope that can be from an EA, MCA or MPA as documented in [Create Azure subscriptions programmatically](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription).

> Please review the [Create Azure subscriptions programmatically](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription) documentation as well as the documentation here [Assign roles to Azure Enterprise Agreement service principal names](https://learn.microsoft.com/azure/cost-management-billing/manage/assign-roles-azure-service-principals) for information on how this works and how to create and assign permissions to a SPN to allow it to create Subscriptions for you as part of a pipeline etc.

The Subscription will be created and placed under the Tenant Root Group, unless the default Management Group has been changed as per [Setting - Default management group](https://learn.microsoft.com/azure/governance/management-groups/how-to/protect-resource-hierarchy#setting---default-management-group)

## Parameters

- [Parameters for Azure Commercial Cloud](generateddocs/subscriptionAlias.bicep.md)

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------
outSubscriptionName | string | `sub-example-001`
outSubscriptionId | string | `5583f55f-65b2-4a3a-87c9-e499c1c587c0`

## Deployment

> **Important Note:** There are 2 parameter files examples provided in the `/parameters` folder of this module. One that contains examples of all possible parameters and another that only contains the minimum required parameters. The minimum version is used in the below examples.

In this example, the Subscription is created upon an EA Account through a tenant-scoped deployment.

> For the below examples we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="alz-SubscriptionAlias-${dateYMD}"
LOCATION="eastus"
PARAMETERS="@infra-as-code/bicep/CRML/subscriptionAlias/parameters/subscriptionAlias.parameters.all.json"
TEMPLATEFILE="infra-as-code/bicep/CRML/subscriptionAlias/subscriptionAlias.bicep"

az deployment tenant create --name ${NAME:0:63} --location $LOCATION --template-file $TEMPLATEFILE --parameters $PARAMETERS
```

### PowerShell

```powershell

$inputObject = @{
  DeploymentName        = 'alz-SubscriptionAlias-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  TemplateParameterFile = 'infra-as-code/bicep/CRML/subscriptionAlias/parameters/subscriptionAlias.parameters.all.json'
  Location              = 'EastUS'
  TemplateFile          = "infra-as-code/bicep/CRML/subscriptionAlias/subscriptionAlias.bicep"
}

New-AzTenantDeployment @inputObject
```

### Output Screenshot

![Example Deployment Output](media/exampleDeploymentOutput.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
