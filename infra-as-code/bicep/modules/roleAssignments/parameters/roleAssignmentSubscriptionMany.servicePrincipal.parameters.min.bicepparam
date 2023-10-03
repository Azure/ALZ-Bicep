using '../roleAssignmentSubscriptionMany.bicep'

param parSubscriptionIds = [
  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
]

param parRoleDefinitionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parAssigneePrincipalType = 'ServicePrincipal'

param parAssigneeObjectId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param parTelemetryOptOut = false
