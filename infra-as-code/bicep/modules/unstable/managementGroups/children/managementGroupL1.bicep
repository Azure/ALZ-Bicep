targetScope = 'tenant'

param parParentManagmentGroupId string
param parManagementGroupName string
param parManagementGroupDisplayName string
param parChildrenManagementGroups array = []

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

module modChildrenManagementGroups 'managementGroupsL2.bicep' = if (length(parChildrenManagementGroups) > 0) {
  name: '${parManagementGroupName}-children'
  params: {
    parParentManagmentGroupId: resParentedManagementGroup.id
    parParentManagmentGroupName: resParentedManagementGroup.name
    parManagementGroupHierarchy: parChildrenManagementGroups
  }
}
