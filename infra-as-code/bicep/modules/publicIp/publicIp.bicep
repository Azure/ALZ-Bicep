metadata name = 'ALZ Bicep - Public IP creation module'
metadata description = 'Module used to set up Public IP for Azure Landing Zones'

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('Azure Region to deploy Public IP Address to.')
param parLocation string = resourceGroup().location

@sys.description('Name of Public IP to create in Azure.')
param parPublicIpName string

@sys.description('Public IP Address SKU.')
param parPublicIpSku object

@sys.description('Properties of Public IP to be deployed.')
param parPublicIpProperties object

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Public IP across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAvailabilityZones array = []

@sys.description('''Resource Lock Configuration for Public IPs.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parResourceLockConfig lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Public IP Module.'
}

@sys.description('Tags to be applied to resource when deployed.')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '3f85b84c-6bad-4c42-86bf-11c233241c22'

resource resPublicIp 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: parPublicIpName
  tags: parTags
  location: parLocation
  zones: parAvailabilityZones
  sku: parPublicIpSku
  properties: parPublicIpProperties
}

resource resPublicIpLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(parResourceLockConfig ?? {}) && parResourceLockConfig.kind != 'None') {
  scope: resPublicIp
  name: parResourceLockConfig.?name ?? '${resPublicIp.name}-lock'
  properties: {
    level: parResourceLockConfig.kind
    notes: parResourceLockConfig.?notes ?? ''
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location, parPublicIpName)}'
  params: {}
}

output outPublicIpId string = resPublicIp.id
output outPublicIpName string = resPublicIp.name
