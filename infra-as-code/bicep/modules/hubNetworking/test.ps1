$ConnectivitySubscriptionId = "9637c0d0-d0a9-4742-bf58-26173af8ab39"
Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId
New-AzResourceGroup -Name 'Hub_Networking_POC_2' `
  -Location 'westus2'
New-AzResourceGroupDeployment `
  -TemplateFile ./hubNetworking.bicep `
  -TemplateParameterFile ./parameters/hubNetworking.parameters.min.json `
  -parLocation 'westus2' `
  -parCompanyPrefix 'alz' `
  -parDnsServerIps '10.0.0.4' `
  -parPublicIpSku 'Standard' `
  -parAzFirewallAvailabilityZones [
    '1,2,3'
  ] `
  -parAzGatewayAvailabilityZones [
  '1,2,3'
  ] `
  -parPrivateDnsZonesEnabled false `
  -ResourceGroupName 'Hub_Networking_POC_2'