# Policy Assignments Library

This directory contains the default policy assignments we make as part of the Azure Landing Zones (aka. Enterprise-scale) in JSON files. These can then be used in variables with the bicep functions of:

- [`json()`](https://docs.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-object#json)
- [`loadTextContent()`](https://docs.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-files#loadtextcontent)

For example:

```bicep
var varPolicyAssignmentDenyPublicIP = json(loadTextContent('infra-as-code/bicep/modules/policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json'))
```

Or you can use the export available in `_policyAssignmentsBicepInput.txt` to copy and paste into a variable to then use to assign policies but manage their properties from the JSON files, like below:

```bicep
targetScope = 'tenant'

@description('The management group scope to which the policy assignments are to be created at. DEFAULT VALUE = "alz"')
param parTargetManagementGroupID string = 'alz'

var varTargetManagementGroupResourceID = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupID)

var varPolicyAssignmentDenyPublicIP = {
  name: 'Deny-Public-IP'
  definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json'))
}

module modPolicyAssignmentDenyPublicIP '../../policyAssignments/policyAssignmentManagementGroup.bicep' = {
  name: 'PolicyAssignmentDenyPublicIP'
  scope: managementGroup('alz')
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyPublicIP.definitionID
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
  }
}
```

> You do not have to use this method, but it is provided to you for ease and is used in the orchestration templates.
>  
> You may also extend the library and add your own assignment files in following the pattern shown in the examples above.
