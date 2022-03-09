targetScope = 'tenant'

@description('Resource ID of the parent Management Group')
param parParentManagmentGroupId string

@description('Name of the parent Management Group')
param parParentManagmentGroupName string 

@description('Management group hierarchy to be deployed.')
param parManagementGroupHierarchy array

module modManagementGroup 'managementGroupL5.bicep' = [for (mg, i) in parManagementGroupHierarchy: {
  name: '${parParentManagmentGroupName}-${mg.name}'
  params: {
    parParentManagmentGroupId: parParentManagmentGroupId
    parManagementGroupName: '${parParentManagmentGroupName}-${mg.name}'
    parManagementGroupDisplayName: mg.displayName
  }
}]
