targetScope = 'subscription'

metadata name = 'ALZ Bicep - Resource Group creation module'
metadata description = 'Module used to create Resource Groups for Azure Landing Zones'

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('Azure Region where Resource Group will be created.')
param parLocation string

@sys.description('Name of Resource Group to be created.')
param parResourceGroupName string

@sys.description('''Resource Lock Configuration for Resource Groups.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parResourceLockConfig lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Resource Group Module.'
}

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = 'b6718c54-b49e-4748-a466-88e3d7c789c8'

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  location: parLocation
  name: parResourceGroupName
  tags: parTags
}

// Create a resource lock at the resource group level
module modResourceGroupLock 'resourceGroupLock.bicep' = if (!empty(parResourceLockConfig ?? {}) && parResourceLockConfig.?kind != 'None') {
  scope: resourceGroup(resResourceGroup.name)
  name: 'deploy-${resResourceGroup.name}-lock'
  params: {
    parResourceGroupName: resResourceGroup.name
    parResourceLockConfig: parResourceLockConfig
  }
}

module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(subscription().subscriptionId, parResourceGroupName)}'
  params: {}
}

output outResourceGroupName string = resResourceGroup.name
output outResourceGroupId string = resResourceGroup.id
