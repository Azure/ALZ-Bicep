using '../policyAssignmentManagementGroup.bicep'

param parPolicyAssignmentName = 'Deploy-MDFC-Config'

param parPolicyAssignmentDisplayName = 'Deploy Microsoft Defender for Cloud configuration'

param parPolicyAssignmentDescription = 'Deploy Microsoft Defender for Cloud configuration and Security Contacts'

param parPolicyAssignmentDefinitionId = '/providers/Microsoft.Management/managementGroups/alz/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config'

param parPolicyAssignmentParameters = {
  emailSecurityContact: {
    value: 'security_contact@replace_me'
  }
  logAnalytics: {
    value: 'alz-la'
  }
  ascExportResourceGroupName: {
    value: 'alz-asc-export'
  }
  ascExportResourceGroupLocation: {
    value: '\${parDefaultRegion}'
  }
  enableAscForServers: {
    value: 'DeployIfNotExists'
  }
  enableAscForSql: {
    value: 'Disabled'
  }
  enableAscForAppServices: {
    value: 'DeployIfNotExists'
  }
  enableAscForStorage: {
    value: 'DeployIfNotExists'
  }
  enableAscForContainers: {
    value: 'DeployIfNotExists'
  }
  enableAscForKeyVault: {
    value: 'DeployIfNotExists'
  }
  enableAscForSqlOnVm: {
    value: 'Disabled'
  }
  enableAscForArm: {
    value: 'DeployIfNotExists'
  }
  enableAscForDns: {
    value: 'DeployIfNotExists'
  }
  enableAscForOssDb: {
    value: 'Disabled'
  }
}

param parPolicyAssignmentNonComplianceMessages = []

param parPolicyAssignmentNotScopes = []

param parTelemetryOptOut = false
