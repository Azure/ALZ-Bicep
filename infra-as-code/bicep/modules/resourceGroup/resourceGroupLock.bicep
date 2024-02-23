metadata name = 'ALZ Bicep - Resource Group lock module'
metadata description = 'Module used to lock Resource Groups for Azure Landing Zones'

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('''Resource Lock Configuration for Resource Groups.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parResourceLockConfig lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Resource Group Module.'
}

@sys.description('Resource Group Name')
param parResourceGroupName string

// Create a resource lock at the resource group level
resource resResourceGroupLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(parResourceLockConfig ?? {}) && parResourceLockConfig.?kind != 'None') {
  name: parResourceLockConfig.?name ?? '${parResourceGroupName}-lock'
  properties: {
    level: parResourceLockConfig.kind
    notes: parResourceLockConfig.?notes
  }
}
