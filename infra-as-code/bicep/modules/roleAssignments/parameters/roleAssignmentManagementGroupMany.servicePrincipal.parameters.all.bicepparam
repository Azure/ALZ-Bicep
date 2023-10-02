using '../roleAssignmentManagementGroupMany.bicep'

param parManagementGroupIds = [
  'alz-platform-connectivity'
  'alz-platform-identity'
]

param parRoleDefinitionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parAssigneePrincipalType = 'ServicePrincipal'

param parAssigneeObjectId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parTelemetryOptOut = false