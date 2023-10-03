using '../policyAssignmentManagementGroup.bicep'

param parPolicyAssignmentName = 'Deny-PublicIP'

param parPolicyAssignmentDisplayName = 'Deny the creation of public IP'

param parPolicyAssignmentDescription = 'This policy denies creation of Public IPs under the assigned scope.'

param parPolicyAssignmentDefinitionId = '/providers/Microsoft.Management/managementGroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'

param parPolicyAssignmentParameters = {}

param parPolicyAssignmentParameterOverrides = {}

param parPolicyAssignmentNonComplianceMessages = []

param parPolicyAssignmentNotScopes = []

param parPolicyAssignmentEnforcementMode = 'Default'

param parPolicyAssignmentIdentityType = 'None'

param parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs = []

param parPolicyAssignmentIdentityRoleAssignmentsSubs = []

param parPolicyAssignmentIdentityRoleAssignmentsResourceGroups = []

param parPolicyAssignmentIdentityRoleDefinitionIds = []

param parTelemetryOptOut = false
