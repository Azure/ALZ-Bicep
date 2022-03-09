targetScope = 'tenant'

param parManagementGroupName string
param parManagementGroupDisplayName string
param parChildrenManagementGroups array = []

resource resRootManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parManagementGroupName
  properties: {
    displayName: parManagementGroupDisplayName
    details: {
    }
  }
}

module modChildrenManagementGroups 'children/managementGroupsL1.bicep' = if (length(parChildrenManagementGroups) > 0) {
  name: '${parManagementGroupName}-children'
  params: {
    parParentManagmentGroupId: resRootManagementGroup.id
    parParentManagmentGroupName: resRootManagementGroup.name
    parManagementGroupHierarchy: parChildrenManagementGroups
  }
}
