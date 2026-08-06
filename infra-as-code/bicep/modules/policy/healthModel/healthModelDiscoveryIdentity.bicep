targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - CloudHealth Discovery Identity'
metadata description = 'Preview (experimental): creates the user-assigned managed identity used by CloudHealth discovery rules.'

@sys.description('Name of the user-assigned managed identity used by the discovery rules.')
param parIdentityName string = 'id-ahm-discovery'

@sys.description('Location for the user-assigned managed identity.')
param parLocation string = resourceGroup().location

resource resIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: parIdentityName
  location: parLocation
}

@sys.description('Resource ID of the discovery user-assigned managed identity.')
output outIdentityId string = resIdentity.id

@sys.description('Principal ID of the discovery user-assigned managed identity.')
output outPrincipalId string = resIdentity.properties.principalId
