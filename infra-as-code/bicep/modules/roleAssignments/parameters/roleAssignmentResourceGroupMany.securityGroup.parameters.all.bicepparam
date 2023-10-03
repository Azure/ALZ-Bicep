using '../roleAssignmentResourceGroupMany.bicep'

param parResourceGroupIds = [
  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/xxxxxxx'
  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/xxxxxxx'
]

param parRoleDefinitionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parAssigneePrincipalType = 'Group'

param parAssigneeObjectId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parTelemetryOptOut = false
