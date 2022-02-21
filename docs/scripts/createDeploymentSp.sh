#!/bin/bash

# Confirm minimum level of access controls
# - Make sure you have administrative access ("Access management for Azure resources") to root MG.
# - Elevate your access in AAD Portal [https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties]
# - You may need to logout and re-login again for your escalated privileges to take.

sp_display_name="spn-alz-bicep"

# login to Azure (browser)
# az login
# or...
# connect to specific tenant
# az login --tenant $name

# create AAD App Registration and Service Principal
az ad app create --display-name $sp_display_name

# get the appId
appId=$(az ad app list --display-name $sp_display_name --query "[0].appId" --output tsv)

# create service principal
az ad sp create --id $appId

# get the appId of the service principal
appId=$(az ad sp list --display-name $sp_display_name --query "[0].appId" --output tsv)

# reset the SP credentials
az ad sp credential reset --name $appId

# assign Owner role at the root MG level to the service principal
az role assignment create --assignee $appId --scope "/" --role "Owner"

# output
echo -e "-------------------------"
echo -e "The service principal was created: [Application ID: $appId]."
echo -e "\n"
echo -e "Login to the Azure CLI with the new deployment service principal:\n
az logout
az login --service-principal -u {APPLICATION ID} -p {CLIENT SECRET} --tenant {AAD TENANT NAME}
az account show"
echo -e "Continue with the first step of the Deployment Flow."
echo -e "-------------------------"