
param (
    #Added this back into parameters as error occurs if multiple tenants are found when using Get-AzTenant
    [Parameter(Mandatory = $true)] [string] $ManagementGroupId,
    [Parameter(Mandatory = $true)] [string] $parLocation,
    [Parameter(Mandatory = $true)] [string] $templateFile,
    [Parameter(Mandatory = $true)] [string] $parameterFile,
    [Parameter(Mandatory = $true)] [string] $parTopLevelManagementGroupPrefix,
    [Parameter(Mandatory = $true)] [string] $parLogAnalyticsWorkSpaceAndAutomationAccountLocation,
    [Parameter(Mandatory = $true)] [string] $parLogAnalyticsWorkspaceResourceID,
    [Parameter(Mandatory = $true)] [string] $parDdosProtectionPlanId
)
$state = 'fail'
$i = 0
$err.clear
while ($i -lt 9 -and $state -eq 'fail') {
    $ErrorActionPreference = "Stop"
    Try {
        New-AzManagementGroupDeployment -Managementgroupid $ManagementGroupId -Location $parLocation -TemplateFile $templateFile -TemplateParameterFile $parameterFile -parTopLevelManagementGroupPrefix $parTopLevelManagementGroupPrefix -parLogAnalyticsWorkSpaceAndAutomationAccountLocation $parLocation -parLogAnalyticsWorkspaceResourceID $parLogAnalyticsWorkspaceResourceID -parDdosProtectionPlanId $parDdosProtectionPlanId
        $state = 'success'
    }
    Catch {
        $i++
        Write-Output "Default policy assignment failed with $error"
        Start-Sleep -Seconds 60
    }
}
