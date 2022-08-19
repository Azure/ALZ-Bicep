$ConnectivitySubscriptionId = "9006c0ed-5386-4b59-b125-bd13aa15a833"
Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId
New-AzResourceGroup -Name 'HUB_PIP_NOZNE' `
  -Location 'westus2'
New-AzResourceGroupDeployment `
  -TemplateFile hubNetworking.bicep `
  -TemplateParameterFile ./parameters/hubNetworking.parameters.min.json `
  -parLocation 'westus2' `
  -parCompanyPrefix 'alz-no-zne' `
  -parDnsServerIps '10.0.0.4' `
  -parPublicIpSku 'Standard' `
  -ResourceGroupName 'HUB_PIP_NOZNE'