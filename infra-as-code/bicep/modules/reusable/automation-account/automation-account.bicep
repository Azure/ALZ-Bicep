/*
SUMMARY: Deploys an Azure Automation Account to a Resource Group.
DESCRIPTION: Deploys an Azure Automation Account to a Resource Group.
AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

@description('Automation account name')
param parName string = 'alz-automation-account'

@description('Region name')
param parRegion string = resourceGroup().location

resource resAutomationAccount 'Microsoft.Automation/automationAccounts@2019-06-01' = {
  name: parName
  location: parRegion
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

output outAutomationAccountName string = resAutomationAccount.name
output outAutomationAccountId string = resAutomationAccount.id
