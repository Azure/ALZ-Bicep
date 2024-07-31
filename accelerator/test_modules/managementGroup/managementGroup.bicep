targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Groups Module with Scope Escape'
metadata description = 'ALZ Bicep Module to set up Management Group structure, using Scope Escaping feature of ARM to allow deployment not requiring tenant root scope access.'

@sys.description('Prefix used for the management group hierarchy. This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@sys.description('Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

@sys.description('Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group.')
param parTopLevelManagementGroupParentId string = ''

resource resTopLevelMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  scope: tenant()
  name: '${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}'
  properties: {
    displayName: parTopLevelManagementGroupDisplayName
    details: {
      parent: {
        id: empty(parTopLevelManagementGroupParentId) ? '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}' : contains(toLower(parTopLevelManagementGroupParentId), toLower('/providers/Microsoft.Management/managementGroups/')) ? parTopLevelManagementGroupParentId : '/providers/Microsoft.Management/managementGroups/${parTopLevelManagementGroupParentId}'
      }
    }
  }
}

// Output Management Group IDs
output outTopLevelManagementGroupId string = resTopLevelMg.id
