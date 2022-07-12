# Input bindings are passed in via param block.
param($QueueItem, $TriggerMetadata)
# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $QueueItem"
$GitHubRepo = $QueueItem.Body.GitHubRepo
Write-Host $GitHubRepo
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"
$perPageCount = 20
#fixme include call to get all closed pull requests, i.e. get all pull requests with state closed or similar, for each push to binding
$closedPrs = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/Azure/ALZ-Bicep/pulls?per_page=$perPageCount&state=closed&page=1"
$closedPrs | Select-Object -unique -Property title, number, state | ForEach-Object {
    $body = @{
        prTitle  = $PSItem.title
        prNumber = $PSItem.number
        prState  = $PSItem.state
    } 
    $body
    Push-OutputBinding -Name pullRequests -Value ([HttpResponseContext]@{
            Body = $body
        })
}