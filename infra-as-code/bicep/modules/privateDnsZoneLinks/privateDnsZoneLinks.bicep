targetScope = 'resourceGroup'

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('The Spoke Virtual Network Resource ID.')
param parSpokeVirtualNetworkResourceId string = ''

@sys.description('The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.')
param parPrivateDnsZoneResourceId string = ''

@sys.description('''Resource Lock Configuration for Private DNS Zone Links.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parResourceLockConfig lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Private DNS Zone Links Module.'
}

var varSpokeVirtualNetworkName = split(parSpokeVirtualNetworkResourceId, '/')[8]

resource resPrivateDnsZoneLinkToSpoke 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (!empty(parPrivateDnsZoneResourceId)) {
  location: 'global'
  name: '${split(parPrivateDnsZoneResourceId, '/')[8]}/dnslink-to-${varSpokeVirtualNetworkName}'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: parSpokeVirtualNetworkResourceId
    }
  }
}

resource lock 'Microsoft.Authorization/locks@2020-05-01' = if (parResourceLockConfig.kind != 'None') {
  scope: resPrivateDnsZoneLinkToSpoke
  name: parResourceLockConfig.?name ?? 'link-to-${varSpokeVirtualNetworkName}-${uniqueString(parPrivateDnsZoneResourceId)}-lock'
  properties: {
    level: parResourceLockConfig.kind
    notes: parResourceLockConfig.?notes ?? ''
  }
}
