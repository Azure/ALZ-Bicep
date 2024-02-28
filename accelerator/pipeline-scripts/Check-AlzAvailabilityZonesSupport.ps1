param (
  [Parameter()]
  [String]$ConnectivitySubscriptionId = "$($env:CONNECTIVITY_SUBSCRIPTION_ID)",

  [Parameter()]
  [String]$ConnectivityResourceGroup = "$($env:CONNECTIVITY_RESOURCE_GROUP)",

  [Parameter()]
  [String]$ConnectivityOption,

  [Parameter()]
  [String]$TemplateParameterFileHubSpoke = "config\custom-parameters\hubNetworking.parameters.all.json",

  [Parameter()]
  [String]$TemplateParameterFileVwan = "config\custom-parameters\vwanConnectivity.parameters.all.json",

  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$apiEndpoint = "https://management.azure.com/subscriptions/$ConnectivitySubscriptionId/providers/Microsoft.Resources/checkZonePeers/?api-version=2022-12-01"
)

$ErrorActionPreference = 'SilentlyContinue'

# Register AvailabilityZonePeering feature if not registered
$featureStatus = (Get-AzProviderFeature -ProviderNamespace "Microsoft.Resources" -FeatureName "AvailabilityZonePeering").RegistrationState

if ($featureStatus -ne "Registered") {
  Write-Host "Registering AvailabilityZonePeering feature"
  Register-AzProviderFeature -FeatureName "AvailabilityZonePeering" -ProviderNamespace "Microsoft.Resources"
  do {
    $featureStatus = (Get-AzProviderFeature -ProviderNamespace "Microsoft.Resources" -FeatureName "AvailabilityZonePeering").RegistrationState
  } until (
    $featureStatus -eq "Registered"
  )
}
Write-Host "AvailabilityZonePeering feature is Successfully registered."

# Check if the location supports Availability Zones
$accessToken = (Get-AzAccessToken).Token
$headers = @{
  "Authorization" = "Bearer $accessToken"
  "Content-Type"  = "application/json"
}

$body = @{
  location        = $Location
  subscriptionIds = @("subscriptions/$ConnectivitySubscriptionId")
} | ConvertTo-Json

try {
  $response = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers $headers
  $numberOfZones = ($response.AvailabilityZonePeers.AvailabilityZone).Count
  if ($numberOfZones -gt 0) {
    # Adding zones support to the hub and spoke parameters file
    if($ConnectivityOption -eq "HubSpoke"){
      $hubSpokeJsonContent = Get-Content -Path $TemplateParameterFileHubSpoke -Raw
      $jsonObject = $hubSpokeJsonContent | ConvertFrom-Json
      $jsonObject.parameters.parAzFirewallAvailabilityZones.value = @("1", "2", "3")
      $jsonObject.parameters.parAzErGatewayAvailabilityZones.value = @("1", "2", "3")
      $jsonObject.parameters.parAzVpnGatewayAvailabilityZones.value = @("1", "2", "3")
      $newhubSpokeJsonContent = $jsonObject | ConvertTo-Json -Depth 10
      Set-Content -Path $TemplateParameterFileHubSpoke -Value $newhubSpokeJsonContent
    }
    # Adding zones support to the vwan parameters file
    elseif ($ConnectivityOption -eq "Vwan") {
      $vwanJsonContent = Get-Content -Path $TemplateParameterFileVwan -Raw
      $jsonObject = $vwanJsonContent | ConvertFrom-Json
      $jsonObject.parameters.parAzFirewallAvailabilityZones.value = @("1", "2", "3")
      $newVwanJsonContent = $jsonObject | ConvertTo-Json -Depth 10
      Set-Content -Path $TemplateParameterFileVwan -Value $newVwanJsonContent
    }
  }
}
catch {
  Write-Host "The region '$Location' doesn't support availability zones!"
}




