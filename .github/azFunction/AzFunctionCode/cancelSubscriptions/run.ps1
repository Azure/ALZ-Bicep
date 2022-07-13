# Input bindings are passed in via param block.
param($QueueItem, $TriggerMetadata)
# Write out the queue message and insertion time to the information log.
Write-Output "PowerShell queue trigger function processed work item: $QueueItem"
$subscriptionId = $QueueItem.Body.subscriptionId
$subscriptionName = $QueueItem.Body.subscriptionName
Write-Output "Subscription to be canceled is $subscriptionName with id: $subscriptionId"
$cancelUri = "https://management.azure.com/subscriptions/$($subscriptionId)/providers/Microsoft.Subscription/cancel?api-version=2020-09-01"
$token = (Get-AzAccessToken).Token 
$secureStringCache = New-Object PSCredential ($username, $token)
Invoke-RestMethod -Method Post -ContentType "application/json" -Authentication Bearer -Token $secureStringCache.Password -Uri $cancelUri
$body = @{
    subscriptionName = $subscriptionName
    subscriptionId   = $subscriptionId
}
Push-OutputBinding -Name canceledSubscriptions -Value ([HttpResponseContext]@{
        Body = $body
    })
Write-Output "Queue item insertion time: $($TriggerMetadata.InsertionTime)"

