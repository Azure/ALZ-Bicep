targetScope = 'managementGroup'

@description('Azure Function App Name')
param parAzFunctionName string

@description('Resource group for Azure Function App')
param parAzFunctionResourceGroupName string = 'cancelsubscription'

@description('Subscription Id for Azure Function App')
param parAzFunctionSubscriptionId string 

// Creating a symbolic name for an existing resource
resource resAzFunction 'Microsoft.Web/sites@2021-03-01' existing = {
  name: parAzFunctionName
  scope: resourceGroup(parAzFunctionSubscriptionId, parAzFunctionResourceGroupName)
}

module modRoleAssignmentManagementGroup '../../../infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroup.bicep' = {
  name: 'Grant-FunctionApp-Owner'
  params: {
    parAssigneeObjectId: resAzFunction.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    parRoleAssignmentNameGuid: '0f69bde8-3eff-476f-93fb-74210d02dbe5'
  }
}
