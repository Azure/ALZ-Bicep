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

param parPolicyAssignmentNonComplianceMessages = []

param parPolicyAssignmentNotScopes = []

param parTelemetryOptOut = false