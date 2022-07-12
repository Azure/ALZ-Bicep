# Input bindings are passed in via param block.
param($QueueItem, $TriggerMetadata)
# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $QueueItem"
$prNumber = $QueueItem.Body.prNumber
$subscriptionName = "sub-unit-test-pr-$prNumber"
Write-Host "Subscription to look for is $subscriptionName"
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"
#MSI to look for subscripition in current tenant
Import-module Az.Accounts -verbose
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName -ErrorAction SilentlyContinue
If ($subscription) {
    Write-Host "found subscription $subscriptionName"
    $subscriptionId = $subscription.Id
    $subscriptionState = $subscription.State
    If ($subscriptionState -eq "Enabled") {
        $body = @{
            subscriptionId = $subscriptionId
            subscriptionName = $subscriptionName
        } 
        Push-OutputBinding -Name subscriptionsToClose -Value ([HttpResponseContext]@{
                Body = $body
            })
    }
    Else {
    Write-Host "Subscription $subscriptionName is already canceled"
    }
}
Else {
    Write-Host "Could not find subscription $subscriptionName"
}
