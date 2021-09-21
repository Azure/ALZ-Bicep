targetScope = 'managementGroup'

param parCurrentTime string = utcNow()

module modManagementGroupBlankDeployment 'blank-mg-deployment.bicep' = {
  name: 'ManagementGroupBlankDeployment-${uniqueString(parCurrentTime)}'
  scope: managementGroup()
}

output outManagementGroupName string = (split(reference(modManagementGroupBlankDeployment.name, '2021-04-01', 'Full').scope, '/')[2])
