metadata name = 'ALZ Bicep - Resource Lock creation module'
metadata description = 'Module used to create a resource lock for an Azure Landing Zones resource'

// I need to determine whether I can pass in a resource ID or if I need pass in a reference to the resource.
// If it is the a reference to the resource, then I will likely need to create a lock.bicep file for each resource type.

@sys.description('Resource name')
param parResourceName string

@sys.description('Resource Lock Configuration Object')
param parResourceLockConfig object

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: parResourceName
}

resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  scope: virtualNetwork
  name: '${parResourceName}-lock'
  properties: {
    level: parResourceLockConfig.level
    notes: parResourceLockConfig.notes
  }
}

