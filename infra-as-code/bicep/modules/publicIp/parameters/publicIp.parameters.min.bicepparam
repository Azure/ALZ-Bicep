using '../publicIp.bicep'

param parPublicIpName = 'alz'

param parPublicIpSku = {
  name: 'Standard'
  tier: 'Regional'
}

param parPublicIpProperties = {
  publicIpAddressVersion: 'IPv4'
  publicIpAllocationMethod: 'Dynamic'
  deleteOption: 'Delete'
  idleTimeoutInMinutes: 4
}

param parTelemetryOptOut = false