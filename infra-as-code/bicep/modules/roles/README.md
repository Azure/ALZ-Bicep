# Module:  Roles

Defines Custom Roles based on Cloud Adoption Framework for Azure guidance. Custom roles are based on the following personas:

  * Subscription owner
  * Application owners (DevOps/AppOps)
  * Network management (NetOps)
  * Security operations (SecOps)

The role definitions are defined in [Identity and access management](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management) recommendations.

## Parameters

The module requires the following inputs:

 Paramenter | Description | Requirement | Example
----------- | ----------- | ----------- | -------
parAssignableScopeManagementGroupId | The management group scope to which the role can be assigned. | Mandatory input | `alz`

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------
outSubscriptionOwnerRoleId | string | Microsoft.Authorization/roleDefinitions/8736d87d-8d31-53be-b952-a04c8d470f69
outApplicationOwnerRoleId | string | Microsoft.Authorization/roleDefinitions/4308c4e6-07d5-534f-9e18-32769872a3f4
outNetworkManagementRoleId | string | Microsoft.Authorization/roleDefinitions/4a200286-e2a0-5239-aa8f-fe0a90dd2eb5
outSecurityOperationsRoleId | string | Microsoft.Authorization/roleDefinitions/b2960c40-d3db-5190-94c1-5b07c9547956

## Deployment

In this example, the custom roles will be deployed at the `alz` management group.  The parameters file provides an example of all required parameters.

### Azure CLI
```bash
az deployment mg create \
  --template-file infra-as-code/bicep/modules/roles/roles.bicep \
  --parameters @infra-as-code/bicep/modules/roles/roles.parameters.example.json \
  --location eastus \
  --management-group-id alz
```

### PowerShell

```powershell
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/roles/roles.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/roles/roles.parameters.example.json `
  -Location eastus `
  -ManagementGroupId alz
```

![Example Deployment Output](media/example-deployment-output.png "Example Deployment Output")

## Bicep Visualizer

![Bicep Visualizer](media/bicep-visualizer.png "Bicep Visualizer")
