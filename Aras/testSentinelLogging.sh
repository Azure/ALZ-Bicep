#!/bin/sh

# --- Aras values
# May need to to az bicep install
source Aras/.env-${ENVIRONMENT}
tags="{\"businessimpact\": \"low\", \"classification\": \"confidential\", \"costcenter\": \"700\", \"createdBy\": \"${CONTACT}\", \"customername\": \"Aras\", \"environment_type\": \"${ENVIRONMENT_TYPE}\", \"function\": \"security\", \"owner\": \"${CONTACT}\", \"projectname\": \"aras-core\"}"
# ---

# For Azure Global regions
# Set Platform management subscription ID as the the current subscription
ManagementSubscriptionId="fac42140-00cf-4c3a-94ca-f672e175c441"
az account set --subscription $ManagementSubscriptionId

# Set the top level MG Prefix in accordance to your environment. This example assumes default 'alz'.
TopLevelMGPrefix="alz"

dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
#GROUP="rg-$TopLevelMGPrefix-logging-001"
GROUP="rg-Sentinel-ARASSRE-dev"
NAME="alz-loggingDeployment-${dateYMD}"
TEMPLATEFILE="infra-as-code/bicep/modules/logging/logging.bicep"
PARAMETERS="@infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json"

# Create Resource Group - optional when using an existing resource group
az group create \
  --name $GROUP \
  --location ${REGION}

# Deploy Module
az deployment group create \
  --name ${NAME:0:63} \
  --resource-group $GROUP \
  --template-file $TEMPLATEFILE \
  --parameters $PARAMETERS \
  --parameters parLogAnalyticsWorkspaceLocation=${REGION} \
      parLogAnalyticsWorkspaceName="la-${APPNAME}-${ENVIRONMENT_TYPE}-${REGION}" \
      parAutomationAccountLocation=${REGION} \
      parTags="${tags}"



