# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
$body = @{
    GitHubRepo = "https://api.github.com/repos/Azure/ALZ-Bicep/pulls"
}  
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name startJob -Value ([HttpResponseContext]@{
        #StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })
