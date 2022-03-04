[CmdletBinding()]
param (
    #Added this back into parameters as error occurs if multiple tenants are found when using Get-AzTenant
    [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Please the Insert Tenant ID (GUID) of your Azure AD tenant e.g.'f73a2b89-6c0e-4382-899f-ea227cd6b68f'")]
    [string]
    $tenantRootGroupID = "<Insert the Tenant ID (GUID) of your Azure AD tenant>",

    [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Insert the name of your intermediate root Management Group e.g. 'Contoso'")]
    [string]
    $intermediateRootGroupID = "<Insert the name of your intermediate root Management Group e.g. Contoso>",

    [Parameter(Mandatory = $true, Position = 4, HelpMessage = "Insert the subscription name of the subscription to wipe e.g. sub-unit-test-pr-108")]
    [string]
    $subscriptionName = "<Insert the subscription Id of the subscription to wipe e.g. sub-unit-test-pr-108>"
)


# Start timer
$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$StopWatch.Start()

$subToMove = Get-AzSubscription -SubscriptionName $subscriptionName

if ($subToMove.State -ne "Disabled") {
    Write-Information "Moving Subscription: '$($subscriptionName)' under Tenant Root Management Group: '$tenantRootGroupID'"
    New-AzManagementGroupSubscription -GroupId $tenantRootGroupID -SubscriptionId $subToMove.Id
}


# For each Subscription in the Intermediate Root Management Group's hierarchy tree, remove all Resources, Resource Groups and Deployments
Write-Information "Removing all Azure Resources, Resource Groups and Deployments from subscription $($subscriptionName)"
Write-Information "Set context to SubscriptionId: '$($subToMove.Id)'"
Set-AzContext -Subscription $subToMove.Id #| Out-Null

# Get all Resource Groups in Subscription
$resources = Get-AzResourceGroup

$resources | ForEach-Object -Parallel {
    Write-Information "Deleting  $_.ResourceGroupName ..."
    Remove-AzResourceGroup -Name $_.ResourceGroupName -Force | Out-Null
}

# Get Deployments for Subscription
$subDeployments = Get-AzSubscriptionDeployment

Write-Information "Removing All Subscription Deployments for: $($subscriptionName)"

# For each Subscription level deployment, remove it
$subDeployments | ForEach-Object -Parallel {
    Write-Information "Removing $($_.DeploymentName) ..."
    Remove-AzSubscriptionDeployment -Id $_.Id
}


# Get all AAD Tenant level deployments
$tenantDeployments = Get-AzTenantDeployment

Write-Information "Removing all Tenant level deployments"

# For each AAD Tenant level deployment, remove it
$tenantDeployments | ForEach-Object -Parallel {
    Write-Information "Removing $($_.DeploymentName) ..."
    Remove-AzTenantDeployment -Id $_.Id
}

# This function only deletes Management Groups in the Intermediate Root Management Group's hierarchy tree and will NOT delete other Intermediate Root level Management Groups and their children e.g. in the case of "canary"
function Remove-Recursively {
    [CmdletBinding(SupportsShouldProcess)]
    param($name)
    # Enters the parent Level
    Write-Information "Entering the scope with $name"
    $parent = Get-AzManagementGroup -GroupId $name -Expand -Recurse

    # Checks if there is any parent level
    if ($null -ne $parent.Children) {
        Write-Information "Found the following Children :"
        Write-Information ($parent.Children | Select-Object Name).Name

        foreach ($children in $parent.Children) {
            # Tries to recur to each child item
            if ($PSCmdlet.ShouldProcess($children.Name)) {
                Remove-Recursively($children.Name)
            }
        }
    }

    # If no children are found at each scope
    Write-Information "No children found in scope $name"
    Write-Information "Removing the scope $name"

    Remove-AzManagementGroup -InputObject $parent -ErrorAction SilentlyContinue
}

# Remove all the Management Groups in Intermediate Root Management Group's hierarchy tree, including itself
Remove-Recursively($intermediateRootGroupID)

# Stop timer
$StopWatch.Stop()

# Display timer output as table
Write-Information "Time taken to complete task:"
$StopWatch.Elapsed | Format-Table