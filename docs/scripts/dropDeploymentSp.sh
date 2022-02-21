#!/bin/bash

sp_display_name="spn-alz-bicep"

# login to Azure (browser)
# az login
# or...
# connect to specific tenant
# az login --tenant $name

# Delete AAD App Registration
# get the appId
appId=$(az ad app list --display-name $sp_display_name --query "[0].appId" --output tsv)
# delete the app
az ad app delete --id $appId

# output
echo -e "-------------------------"
echo "The service principal [$appId] was deleted."
echo -e "-------------------------"