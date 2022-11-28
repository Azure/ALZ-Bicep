
param (
    #Added this back into parameters as error occurs if multiple tenants are found when using Get-AzTenant
    [Parameter(Mandatory = $true)] [string] $ManagementGroupId,
    [Parameter(Mandatory = $true)] [string] $parLocation,
    [Parameter(Mandatory = $true)] [string] $templateFile,
    [Parameter(Mandatory = $true)] [string] $parameterFile,
    [Parameter(Mandatory = $true)] [string] $parTopLevelManagementGroupPrefix,
    [Parameter(Mandatory = $true)] [string] $parLogAnalyticsWorkSpaceAndAutomationAccountLocation,
    [Parameter(Mandatory = $true)] [string] $parLogAnalyticsWorkspaceResourceID,
    [Parameter(Mandatory = $true)] [string] $parDdosProtectionPlanId,
    [Parameter(Mandatory = $true)] [string] $parPrivateDnsResourceGroupId
)
$state = 'fail'
$i = 0
$err.clear
while ($i -lt 4 -and $state -eq 'fail') {
    $ErrorActionPreference = "Stop"
    Try {
        New-AzManagementGroupDeployment -Managementgroupid $ManagementGroupId -Location $parLocation -TemplateFile $templateFile -TemplateParameterFile $parameterFile -parTopLevelManagementGroupPrefix $parTopLevelManagementGroupPrefix -parLogAnalyticsWorkSpaceAndAutomationAccountLocation $parLogAnalyticsWorkSpaceAndAutomationAccountLocation -parLogAnalyticsWorkspaceResourceID $parLogAnalyticsWorkspaceResourceID -parDdosProtectionPlanId $parDdosProtectionPlanId -parPrivateDnsResourceGroupId $parPrivateDnsResourceGroupId
        $state = 'success'
    }
    Catch {
        $i++
        Write-Output "ALZ Default Policy Assignments module failed to deploy with $error"
        Write-Output "Iteration number $i"
        Write-Output "Will retry in 30 seconds"
        Start-Sleep -Seconds 30
    }
}
If ($state -eq 'fail') {
    Throw "ALZ Default Policy Assignments module failed to deploy after $i attempts"
}
