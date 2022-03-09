targetScope = 'tenant'

param parParentManagmentGroupId string
param parManagementGroupName string
param parManagementGroupDisplayName string

resource resParentedManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parManagementGroupName
  properties: {
    displayName: parManagementGroupDisplayName
    details: {
      parent: {
        id: parParentManagmentGroupId
      }
    }
  }
}
