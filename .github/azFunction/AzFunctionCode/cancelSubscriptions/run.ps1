# Input bindings are passed in via param block.
param($QueueItem, $TriggerMetadata)
# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $QueueItem"
$subscriptionId = $QueueItem.Body.subscriptionId
$subscriptionName = $QueueItem.Body.subscriptionName
Write-Host "Subscription to be canceled is $subscriptionName with id: $subscriptionId"
$cancelUri = "https://management.azure.com/subscriptions/$($subscriptionId)/providers/Microsoft.Subscription/cancel?api-version=2020-09-01"
$token = (Get-AzAccessToken).Token | ConvertTo-SecureString -AsPlainText -Force
Write-Host "Invoke-RestMethod -Method Post -ContentType "application/json" -Authentication Bearer -Token $token -Uri $cancelUri"
Invoke-RestMethod -Method Post -ContentType "application/json" -Authentication Bearer -Token $token -Uri $cancelUri
#MSI to look for subscripition in current tenant
# fixme some code to cancel subscription and possibly verify that it happened
$body = @{
    subscriptionName = $subscriptionName
    subscriptionId = $subscriptionId
} 
Push-OutputBinding -Name canceledSubscriptions -Value ([HttpResponseContext]@{
        Body = $body
    })
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"

