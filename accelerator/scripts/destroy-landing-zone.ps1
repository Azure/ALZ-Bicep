## This script is derived from the original by Jack Tracey, which you can find here: https://github.com/jtracey93/PublicScripts/blob/master/Azure/PowerShell/Enterprise-scale/Wipe-ESLZAzTenant.ps1

param (
    [bool]$whatIfEnabled = $true,
    [string]$intermediateRootGroupID = $env:MANAGEMENT_GROUP_ID,
    [string]$tenantRootGroupID = $env:ROOT_PARENT_MANAGEMENT_GROUP_ID
)

if($whatIfEnabled) {
  Write-Warning "The deploy stage of this run will delete all aspects of your landing zone. This includes all resources in your platform subscriptions. Please ensure you have a backup of any data you wish to keep."
  Write-Warning "DANGER! DO NOT APPROVE THIS RUN UNLESS YOU ARE CERTAIN YOU WANT TO DELETE EVERYTHING."
  exit 0
}

if ($tenantRootGroupID -eq "") {
    $tenantRootGroupID = (Get-AzContext).Tenant.TenantId
}
$resetMdfcTierOnSubs = $true

## Orphaned Role Assignements Function
function Invoke-RemoveOrphanedRoleAssignment {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()][String[]]$SubscriptionId
    )

    $originalCtx = Get-AzContext

    $WhatIfPrefix = ""
    if ($WhatIfPreference) {
        $WhatIfPrefix = "What if: "
    }

    # Get the latest stable API version
    $roleAssignmentsApiVersions = ((Get-AzResourceProvider -ProviderNamespace Microsoft.Authorization).ResourceTypes | Where-Object ResourceTypeName -eq roleAssignments).ApiVersions
    $latestRoleAssignmentsApiVersions = $roleAssignmentsApiVersions | Where-Object {$_ -notlike '*-preview'} | Sort-Object -Descending | Select-Object -First 1
    Write-Information "Using Role Assignments API Version : $($latestRoleAssignmentsApiVersions)" -InformationAction Continue

    foreach ($subId in $SubscriptionId) {

        # Use Rest API to ensure correct permissions are assigned when looking up
        # whether identity exists, otherwise Get-AzRoleAssignment will always
        # return `objectType : "unknown"` for all assignments with no errors.

        # Get Role Assignments
        $getRequestPath = "/subscriptions/$($subId)/providers/Microsoft.Authorization/roleAssignments?api-version=$($latestRoleAssignmentsApiVersions)"
        $getResponse = Invoke-AzRestMethod -Method "GET" -Path $getRequestPath
        $roleAssignments = ($getResponse.Content | ConvertFrom-Json).value

        # Check for valid response
        if ($getResponse.StatusCode -ne "200") {
            throw $getResponse.Content
        }
        try {
            # If invalid response, $roleAssignments will be null and throw an error
            $roleAssignments.GetType() | Out-Null
        }
        catch {
            throw $getResponse.Content
        }

        # Get a list of assigned principalId values and lookup against AAD
        $principalsRequestUri = "https://graph.microsoft.com/v1.0/directoryObjects/microsoft.graph.getByIds"
        $principalsRequestBody = @{
            ids = $roleAssignments.properties.principalId
        } | ConvertTo-Json -Depth 10
        $principalsResponse = Invoke-AzRestMethod -Method "POST" -Uri $principalsRequestUri -Payload $principalsRequestBody -WhatIf:$false
        $principalIds = ($principalsResponse.Content | ConvertFrom-Json).value.id

        # Find all Role Assignments where the principalId is not found in AAD
        $orphanedRoleAssignments = $roleAssignments | Where-Object {
            ($_.properties.scope -eq "/subscriptions/$($subId)") -and
            ($_.properties.principalId -notin $principalIds)
        }

        # Delete orphaned Role Assignments
        Write-Information "$($WhatIfPrefix)Deleting [$($orphanedRoleAssignments.Length)] orphaned Role Assignments for Subscription [$($subId)]" -InformationAction Continue
        $orphanedRoleAssignments | ForEach-Object {
            if ($PSCmdlet.ShouldProcess("$($_.id)", "Remove-AzRoleAssignment")) {
                $deleteRequestPath = "$($_.id)?api-version=$($latestRoleAssignmentsApiVersions)"
                $deleteResponse = Invoke-AzRestMethod -Method "DELETE" -Path $deleteRequestPath
                # Check for valid response
                if ($deleteResponse.StatusCode -ne "200") {
                    throw $deleteResponse.Content
                }
            }
        }
    }
    Set-AzContext $originalCtx -WhatIf:$false | Out-Null
}

#Toggle to stop warnings with regards to DisplayName and DisplayId
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# Start timer
$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$StopWatch.Start()

# Get all Subscriptions that are in the Intermediate Root Management Group's hierarchy tree
$intermediateRootGroupChildSubscriptions = Search-AzGraph -Query "resourcecontainers | where type =~ 'microsoft.resources/subscriptions' | mv-expand mgmtGroups=properties.managementGroupAncestorsChain | where mgmtGroups.name =~ '$intermediateRootGroupID' | project subName=name, subID=subscriptionId, subState=properties.state, aadTenantID=tenantId, mgID=mgmtGroups.name, mgDisplayName=mgmtGroups.displayName"

Write-Host "Moving all subscriptions under root management group" -ForegroundColor Yellow

# For each Subscription in Intermediate Root Management Group's hierarchy tree, move it to the Tenant Root Management Group
$intermediateRootGroupChildSubscriptions | ForEach-Object -Parallel {
    # The name 'Tenant Root Group' doesn't work. Instead, use the GUID of your Tenant Root Group
    if ($_.subState -ne "Disabled") {
        Write-Host "Moving Subscription: '$($_.subName)' under Tenant Root Management Group: '$($using:tenantRootGroupID)'" -ForegroundColor Cyan
        New-AzManagementGroupSubscription -GroupId $using:tenantRootGroupID -SubscriptionId $_.subID | Out-Null
    }
}

# For each Subscription in the Intermediate Root Management Group's hierarchy tree, remove all Resources, Resource Groups and Deployments
Write-Host "Removing all Azure Resources, Resource Groups and Deployments from Subscriptions in scope" -ForegroundColor Yellow

ForEach ($subscription in $intermediateRootGroupChildSubscriptions) {
    Write-Host "Set context to Subscription: '$($subscription.subName)'" -ForegroundColor Cyan
    Set-AzContext -Subscription $subscription.subID | Out-Null

    # Get all Resource Groups in Subscription
    $resources = Get-AzResourceGroup

    $resources | ForEach-Object -Parallel {
        Write-Host "Deleting " $_.ResourceGroupName "..." -ForegroundColor Red
        Remove-AzResourceGroup -Name $_.ResourceGroupName -Force | Out-Null
    }
    
    # Get Deployments for Subscription
    $subDeployments = Get-AzSubscriptionDeployment

    Write-Host "Removing All Subscription Deployments for: $($subscription.subName)" -ForegroundColor Yellow 
    
    # For each Subscription level deployment, remove it
    $subDeployments | ForEach-Object -Parallel {
        Write-Host "Removing $($_.DeploymentName) ..." -ForegroundColor Red
        Remove-AzSubscriptionDeployment -Id $_.Id | Out-Null
    }

    # Set MDFC tier to Free for each Subscription
    if ($resetMdfcTierOnSubs) {
        Write-Host "Resetting MDFC tier to Free for Subscription: $($subscription.subName)" -ForegroundColor Yellow
        
        $currentMdfcForSubUnfiltered = Get-AzSecurityPricing
        $currentMdfcForSub = $currentMdfcForSubUnfiltered | Where-Object { $_.PricingTier -ne "Free" }

        ForEach ($mdfcPricingTier in $currentMdfcForSub) {
            Write-Host "Resetting $($mdfcPricingTier.Name) to Free MDFC Pricing Tier for Subscription: $($subscription.subName)" -ForegroundColor Yellow
            
            Set-AzSecurityPricing -Name $mdfcPricingTier.Name -PricingTier 'Free' | Out-Null
        }
    }
}

# This function only deletes Management Groups in the Intermediate Root Management Group's hierarchy tree and will NOT delete other Intermediate Root level Management Groups and their children e.g. in the case of "canary"
function Remove-Recursively($name) {
    # Enters the parent Level
    Write-Host "Entering the scope with $name" -ForegroundColor Green
    $parent = Get-AzManagementGroup -GroupId $name -Expand -Recurse

    # Checks if there is any parent level
    if ($null -ne $parent.Children) {
        Write-Host "Found the following Children :" -ForegroundColor Yellow
        Write-host ($parent.Children | Select-Object Name).Name -ForegroundColor White

        foreach ($children in $parent.Children) {
            # Tries to recur to each child item
            Remove-Recursively($children.Name)
        }
    }

    # If no children are found at each scope
    Write-Host "No children found in scope $name" -ForegroundColor Yellow
    Write-Host "Removing the scope $name" -ForegroundColor Red
    
    Remove-AzManagementGroup -InputObject $parent | Out-Null
}

# Remove all the Management Groups in Intermediate Root Management Group's hierarchy tree, including itself
Remove-Recursively($intermediateRootGroupID)

# Remove orphaned/identity not found RBAC role assignments from each subscription
Write-Host "Removing Oprhaned/Identity Not Found Role Assignments for all subscriptions: $($intermediateRootGroupChildSubscriptions.subID)" -ForegroundColor Yellow
Invoke-RemoveOrphanedRoleAssignment -SubscriptionId $intermediateRootGroupChildSubscriptions.subID

# Stop timer
$StopWatch.Stop()

# Display timer output as table
Write-Host "Time taken to complete task:" -ForegroundColor Yellow
$StopWatch.Elapsed | Format-Table