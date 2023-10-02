using '../policyAssignmentManagementGroup.bicep'

param parPolicyAssignmentName = 'Deploy-ASCDF-Config'

param parPolicyAssignmentDisplayName = 'Deploy Microsoft Defender for Cloud configuration'

param parPolicyAssignmentDescription = 'Deploy Microsoft Defender for Cloud and Security Contacts'

param parPolicyAssignmentDefinitionId = '/providers/Microsoft.Management/managementGroups/alz/providers/Microsoft.Authorization/policySetDefinitions/Deploy-ASCDF-Config'

param parPolicyAssignmentParameters = {
  emailSecurityContact: {
    value: 'security_contact@replace_me'
  }
  logAnalytics: {
    value: 'alz-log-analytics'
  }
  ascExportResourceGroupName: {
    value: 'alz-asc-export'
  }
  ascExportResourceGroupLocation: {
    value: '\${parDefaultRegion}'
  }
  enableAscForServers: {
    value: 'Disabled'
  }
  enableAscForSql: {
    value: 'Disabled'
  }
}

param parPolicyAssignmentParameterOverrides = {}

param parPolicyAssignmentNonComplianceMessages = []

param parPolicyAssignmentNotScopes = []

param parPolicyAssignmentEnforcementMode = 'Default'

param parPolicyAssignmentIdentityType = 'SystemAssigned'

param parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs = [
  'alz-platform'
]

param parPolicyAssignmentIdentityRoleAssignmentsSubs = []

param parPolicyAssignmentIdentityRoleAssignmentsResourceGroups = []

param parPolicyAssignmentIdentityRoleDefinitionIds = [
  '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
]

param parTelemetryOptOut = false