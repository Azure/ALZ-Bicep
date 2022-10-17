# Policy Assignments Library

This directory contains the default policy assignments we make as part of the Azure Landing Zones (aka. Enterprise-scale) in JSON files. These can then be used in variables with the bicep functions of:

- [`json()`](https://docs.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-object#json)
- [`loadJsonContent()`](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-files#loadjsoncontent)

For example:

```bicep
var varPolicyAssignmentDenyPublicIp = loadJsonContent('infra-as-code/bicep/modules/policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json')
```

Or you can use the export available in `_policyAssignmentsBicepInput.txt` to copy and paste into a variable to then use to assign policies but manage their properties from the JSON files, like below:

```bicep
targetScope = 'tenant'

@description('The management group scope to which the policy assignments are to be created at. DEFAULT VALUE = "alz"')
param parTargetManagementGroupId string = 'alz'

var varTargetManagementGroupResourceId = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupId)

var varPolicyAssignmentDenyPublicIp = {
  name: 'Deny-Public-IP'
  definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'
  libDefinition: loadJsonContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json')
}

module modPolicyAssignmentDenyPublicIP '../../policyAssignments/policyAssignmentManagementGroup.bicep' = {
  name: 'PolicyAssignmentDenyPublicIP'
  scope: managementGroup('alz')
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIp.definitionId
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIp.libDefinition.properties.description
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIp.libDefinition.properties.displayName
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIp.libDefinition.name
  }
}
```

> You do not have to use this method, but it is provided to you for ease and is used in the orchestration templates.
>
> You may also extend the library and add your own assignment files in following the pattern shown in the examples above.
