targetScope = 'resourceGroup'

@maxLength(8)
param workloadShortName string = 'jt'

@allowed([
  'northeurope'
  'westeurope'
  'uksouth'
])
param regionLong string = 'northeurope'

@allowed([
  'neu'
  'weu'
  'uks'
])
param regionShort string = 'neu'

@maxLength(10)
param shareName string

@description('The size of the share in GB.')
param shareSizeInGb int

var tags = {
  Cloud: 'Azure'
  Envrionment: 'Lab'
  'Used-For': 'Work Testing'
  TemporaryResource: 'No'
  Service: 'MSIX App Attach'
}

var stgName = 'stg${regionShort}${workloadShortName}001'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stgName
  location: regionLong
  tags: tags
  kind: 'FileStorage'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = {
  name: '${stg.name}\'/default/${shareName}'
  properties: {
    enabledProtocols: 'SMB'
    shareQuota: 100
  }
}


