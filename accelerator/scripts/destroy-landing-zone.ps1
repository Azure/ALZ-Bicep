## This script is derived from the original by Jack Tracey, which you can find here: https://github.com/jtracey93/PublicScripts/blob/master/Azure/PowerShell/Enterprise-scale/Wipe-ESLZAzTenant.ps1

param (
    [bool]$whatIfEnabled = $true,
    [string]$prefix = $env:PREFIX,
    [string]$intermediateRootGroupID = $env:MANAGEMENT_GROUP_ID,
    [string]$tenantRootGroupID = $env:ROOT_PARENT_MANAGEMENT_GROUP_ID,
    [string]$connectivitySubscriptionId = $env:CONNECTIVITY_SUBSCRIPTION_ID,
    [string]$identitySubscriptionId = $env:IDENTITY_SUBSCRIPTION_ID,
    [string]$managementSubscriptionId = $env:MANAGEMENT_SUBSCRIPTION_ID
)

if($whatIfEnabled) {
  Write-Warning "The deploy stage of this run will delete all aspects of your landing zone. This includes all resources in your platform subscriptions. Please ensure you have a backup of any data you wish to keep."
  Write-Warning "DANGER! DO NOT APPROVE THIS RUN UNLESS YOU ARE CERTAIN YOU WANT TO DELETE EVERYTHING."
  exit 0
}

$managementGroups = Get-AzManagementGroup
$managementGroup = $managementGroups | Where-Object { $_.Name -eq $intermediateRootGroupID }
if($null -eq $managementGroup) {
    Write-Warning "The $intermediateRootGroupID does not exist, so there is nothing to delete."
    exit 0
}

if ($tenantRootGroupID -eq "") {
    $tenantRootGroupID = (Get-AzContext).Tenant.TenantId
}
$resetMdfcTierOnSubs = $true

#Toggle to stop warnings with regards to DisplayName and DisplayId
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# Start timer
$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$StopWatch.Start()

# Get all Subscriptions that are in the Intermediate Root Management Group's hierarchy tree
$intermediateRootGroupChildSubscriptions = Search-AzGraph -Query "resourcecontainers | where type =~ 'microsoft.resources/subscriptions' | mv-expand mgmtGroups=properties.managementGroupAncestorsChain | where mgmtGroups.name =~ '$intermediateRootGroupID' | project subName=name, subID=subscriptionId, subState=properties.state, aadTenantID=tenantId, mgID=mgmtGroups.name, mgDisplayName=mgmtGroups.displayName"

Write-Output "Moving all subscriptions under root management group"

# For each Subscription in Intermediate Root Management Group's hierarchy tree, move it to the Tenant Root Management Group
$intermediateRootGroupChildSubscriptions | ForEach-Object -Parallel {
    # The name 'Tenant Root Group' doesn't work. Instead, use the GUID of your Tenant Root Group
    if ($_.subState -ne "Disabled") {
        Write-Output "Moving Subscription: '$($_.subName)' under Tenant Root Management Group: '$($using:tenantRootGroupID)'"
        New-AzManagementGroupSubscription -GroupId $using:tenantRootGroupID -SubscriptionId $_.subID | Out-Null
    }
}

# For each Subscription in the Intermediate Root Management Group's hierarchy tree, remove all Resources, Resource Groups and Deployments
Write-Output "Removing all Azure Resources, Resource Groups and Deployments from Subscriptions in scope"

$subscriptionsToClean = @()
ForEach ($subscription in $intermediateRootGroupChildSubscriptions) {
    $subscriptionsToClean += @{
        name = $subscription.subName
        id   = $subscription.subID
    }
}

$subscriptionIds = $subscriptionsToClean | Select-Object -ExpandProperty id

if($subscriptionIds -notcontains $managementSubscriptionId) {
    $subscriptionsToClean += @{
        name = "Management"
        id   = $managementSubscriptionId
    }
    $subscriptionIds += $managementSubscriptionId
}

if($subscriptionIds -notcontains $identitySubscriptionId) {
    $subscriptionsToClean += @{
        name = "Identity"
        id   = $identitySubscriptionId
    }
    $subscriptionIds += $identitySubscriptionId
}

if($subscriptionIds -notcontains $connectivitySubscriptionId) {
    $subscriptionsToClean += @{
        name = "Connectivity"
        id   = $connectivitySubscriptionId
    }
    $subscriptionIds += $connectivitySubscriptionId
}

ForEach ($subscription in $subscriptionsToClean) {
    Write-Output "Set context to Subscription: '$($subscription.name)'"
    Set-AzContext -Subscription $subscription.id | Out-Null

    # Get all Resource Groups in Subscription
    $resourceGroups = Get-AzResourceGroup

    $resourceGroupsToRemove = @()
    ForEach ($resourceGroup in $resourceGroups) {
        if ($resourceGroup.ResourceGroupName -like "rg-$prefix*") {
            $resourceGroupsToRemove += $resourceGroup.ResourceGroupName
        }
    }

    $resourceGroupsToRemove | ForEach-Object -Parallel {
        Write-Output "Deleting $_..."
        Remove-AzResourceGroup -Name $_ -Force | Out-Null
    }

    # Get Deployments for Subscription
    $subDeployments = Get-AzSubscriptionDeployment

    Write-Output "Removing All Successful Subscription Deployments for: $($subscription.name)"

    $deploymentsToRemove = @()
    ForEach ($deployment in $subDeployments) {
        if ($deployment.DeploymentName -like "$prefix*" -and $deployment.ProvisioningState -eq "Succeeded") {
            $deploymentsToRemove += $deployment
        }
    }

    # For each Subscription level deployment, remove it
    $deploymentsToRemove | ForEach-Object -Parallel {
        Write-Output "Removing $($_.DeploymentName) ..."
        Remove-AzSubscriptionDeployment -Id $_.Id | Out-Null
    }

    # Set MDFC tier to Free for each Subscription
    if ($resetMdfcTierOnSubs) {
        Write-Output "Resetting MDFC tier to Free for Subscription: $($subscription.name)"

        $currentMdfcForSubUnfiltered = Get-AzSecurityPricing
        $currentMdfcForSub = $currentMdfcForSubUnfiltered | Where-Object { $_.PricingTier -ne "Free" }

        ForEach ($mdfcPricingTier in $currentMdfcForSub) {
            Write-Output "Resetting $($mdfcPricingTier.Name) to Free MDFC Pricing Tier for Subscription: $($subscription.name)"

            Set-AzSecurityPricing -Name $mdfcPricingTier.Name -PricingTier 'Free' | Out-Null
        }
    }
}

# This function only deletes Management Groups in the Intermediate Root Management Group's hierarchy tree and will NOT delete other Intermediate Root level Management Groups and their children e.g. in the case of "canary"

function Remove-Recursively {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$name
    )
    if($PSCmdlet.ShouldProcess($name, "Remove-AzManagementGroup")) {
        # Enters the parent Level
        Write-Output "Entering the scope with $name"
        $parent = Get-AzManagementGroup -GroupId $name -Expand -Recurse

        # Checks if there is any parent level
        if ($null -ne $parent.Children) {
            Write-Output "Found the following Children :"
            Write-Output ($parent.Children | Select-Object Name).Name

            foreach ($children in $parent.Children) {
                # Tries to recur to each child item
                Remove-Recursively($children.Name)
            }
        }

        # If no children are found at each scope
        Write-Output "No children found in scope $name"
        Write-Output "Removing the scope $name"

        Remove-AzManagementGroup -InputObject $parent | Out-Null
    }
}

# Check if Management Group exists for idempotency
$managementGroups = Get-AzManagementGroup
$managementGroup = $managementGroups | Where-Object { $_.Name -eq $intermediateRootGroupID }

if($null -eq $managementGroup) {
    Write-Output "Management Group with ID: '$intermediateRootGroupID' does not exist."
} else {
    Write-Output "Management Group with ID: '$intermediateRootGroupID' exists. Proceeding with deletion."

    # Remove all the Management Groups in Intermediate Root Management Group's hierarchy tree, including itself
    Remove-Recursively($intermediateRootGroupID)
}

# Stop timer
$StopWatch.Stop()

# Display timer output as table
Write-Output "Time taken to complete task:"
$StopWatch.Elapsed | Format-Table
