# From "Bicep Build & Lint All Modules" in .github/workflows/bicep-build-to-validate.yml
$output = @()
Get-ChildItem -Recurse -Filter '*.bicep' -Exclude 'callModuleFromACR.example.bicep', 'orchHubSpoke.bicep' | ForEach-Object {
  Write-Information "==> Attempting Bicep Build For File: $_" -InformationAction Continue
  $bicepOutput = bicep build $_.FullName 2>&1
  if ($LastExitCode -ne 0) {
    foreach ($item in $bicepOutput) {
      $output += "$($item) `r`n"
    }
  }
  Else {
    echo "Bicep Build Successful for File: $_"
  }
}
if ($output.length -gt 0) {
  throw $output
}
