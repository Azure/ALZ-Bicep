targetScope = 'managementGroup'

module modManagementGroupBlankDeployment 'blank-mg-deployment.bicep' = {
  name: 'ManagementGroupBlankDeployment'
  scope: managementGroup()
}

output outManagementGroupName string = (split(reference(modManagementGroupBlankDeployment.name, '2021-04-01', 'Full').scope, '/')[2])
