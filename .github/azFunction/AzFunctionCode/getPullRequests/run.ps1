# Input bindings are passed in via param block.
param($QueueItem, $TriggerMetadata)
# Write out the queue message and insertion time to the information log.
Write-Output "PowerShell queue trigger function processed work item: $QueueItem"
Write-Output "Queue item insertion time: $($TriggerMetadata.InsertionTime)"
$perPageCount = 0
$closedPrs = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/Azure/ALZ-Bicep/pulls?per_page=$perPageCount&state=closed&page=1"
$closedPrs | Select-Object -unique -Property title, number, state | ForEach-Object {
    $body = @{
        prTitle  = $PSItem.title
        prNumber = $PSItem.number
        prState  = $PSItem.state
    }
    Push-OutputBinding -Name pullRequests -Value ([HttpResponseContext]@{
            Body = $body
        })
}