####################################
# Invoke-GitHubReleaseFetcher.ps1 #
####################################
# Version: 1.2.0
# Last Modified: 26/10/2022
# Author: Jack Tracey
# Source: https://github.com/jtracey93/PublicScripts/blob/master/GitHub/PowerShell/Invoke-GitHubReleaseFetcher.ps1

<#
.SYNOPSIS
Checks for the releases of a GitHub repository and downloads the latest release or all releases and pulls it into a specified directory, one for each version.
.DESCRIPTION
Checks for the releases of a GitHub repository and downloads the latest release or all releases and pulls it into a specified directory, one for each version.

.EXAMPLE
# Sync only latest release to PWD and keep only "version.json" file and "infra-as-code" directory (recursively)
$keepThese = @("version.json", "infra-as-code")
./Invoke-GitHubReleaseFetcher.ps1 -githubRepoUrl "https://github.com/Azure/ALZ-Bicep" -directoryAndFilesToKeep $keepThese

# Sync only all releases to PWD and keep only "version.json" file and "infra-as-code" directory (recursively)
$keepThese = @("version.json", "infra-as-code")
./Invoke-GitHubReleaseFetcher.ps1 -githubRepoUrl "https://github.com/Azure/ALZ-Bicep" -syncAllReleases:$true -directoryAndFilesToKeep $keepThese

.NOTES
# Release notes 25/10/2021 - V1.0.0:
- Initial release.

# Release notes 26/10/2021 - V1.1.0:
- Add support to move all extracted contents to release directories if $directoryAndFilesToKeep is not specified or is a empty array (which is the default).

# Release notes 30/10/2021 - V1.2.0:
- Add missing if condition to stop all files being added regardless of what is passed into `directoryAndFilesToKeep`.
#>

# Check for pre-reqs
#Requires -PSEdition Core

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification = "Required for colour outputs")]

[CmdletBinding()]
param (
  #Added this back into parameters as error occurs if multiple tenants are found when using Get-AzTenant
  [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Please the provide the full URL of the GitHub repository you wish to check for the latest release.")]
  [string]
  $githubRepoUrl,

  [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Sync all releases from the specified GitHub repository. Defaults to false.")]
  [bool]
  $syncAllReleases = $false,

  [Parameter(Mandatory = $false, Position = 3, HelpMessage = "The directory to download the releases to. Defaults to the current directory.")]
  [string]
  $directoryForReleases = "$PWD/releases",

  [Parameter(Mandatory = $false, Position = 4, HelpMessage = "An array of strings contianing the paths to the directories or files that you wish to keep when downloading and extracting from the releases.")]
  [array]
  $directoryAndFilesToKeep = @()
)

# Start timer
$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$StopWatch.Start()

# Split Repo URL into parts
$repoOrgPlusRepo = $githubRepoUrl.Split("/")[-2..-1] -join "/"

# Get releases on repo
$repoReleasesUrl = "https://api.github.com/repos/$repoOrgPlusRepo/releases"
$allRepoReleases = Invoke-RestMethod $repoReleasesUrl

Write-Host ""
Write-Host "=====> Checking for releases on GitHub Repo: $repoOrgPlusRepo" -ForegroundColor Cyan
Write-Host ""
Write-Host "=====> All available releases on GitHub Repo: $repoOrgPlusRepo" -ForegroundColor Cyan
$allRepoReleases | Select-Object name, tag_name, published_at, prerelease, draft, html_url | Format-Table -AutoSize

# Get latest release on repo
$latestRepoRelease = $allRepoReleases | Where-Object { $_.prerelease -eq $false } | Where-Object { $_.draft -eq $false } | Sort-Object -Descending published_at | Select-Object -First 1

Write-Host ""
Write-Host "=====> Latest available release on GitHub Repo: $repoOrgPlusRepo" -ForegroundColor Cyan
$latestRepoRelease | Select-Object name, tag_name, published_at, prerelease, draft, html_url | Format-Table -AutoSize

# Check if directory exists
Write-Host ""
Write-Host "=====> Checking if directory for releases exists: $directoryForReleases" -ForegroundColor Cyan

if (!(Test-Path $directoryForReleases)) {
  Write-Host ""
  Write-Host "Directory does not exist for releases, will now create: $directoryForReleases" -ForegroundColor Yellow
  New-Item -ItemType Directory -Path $directoryForReleases
}

# Pull all releases into directories
if ($syncAllReleases -eq $true) {
  Write-Host ""
  Write-Host "=====> Syncing all releases of $repoOrgPlusRepo into $directoryForReleases" -ForegroundColor Cyan

  foreach ($release in $allRepoReleases) {
    $releaseDirectory = "$directoryForReleases/$($release.tag_name)"

    Write-Host ""
    Write-Host "===> Checking if directory for release version exists: $releaseDirectory" -ForegroundColor Cyan

    if (!(Test-Path $releaseDirectory)) {
      Write-Host ""
      Write-Host "Directory does not exist for release $($release.tag_name), will now create: $releaseDirectory" -ForegroundColor Yellow
      New-Item -ItemType Directory -Path $releaseDirectory
    }

    Write-Host ""
    Write-Host "===> Checking if any content exists inside of $releaseDirectory" -ForegroundColor Cyan

    $contentInReleaseDirectory = Get-ChildItem -Path $releaseDirectory -Recurse -ErrorAction SilentlyContinue

    if ($null -eq $contentInReleaseDirectory) {
      Write-Host ""
      Write-Host "===> Pulling and extracting release $($release.tag_name) into $releaseDirectory" -ForegroundColor Cyan
      New-Item -ItemType Directory -Path "$releaseDirectory/tmp"
      Invoke-WebRequest -Uri "https://github.com/$repoOrgPlusRepo/archive/refs/tags/$($release.tag_name).zip" -OutFile "$releaseDirectory/tmp/$($release.tag_name).zip"
      Expand-Archive -Path "$releaseDirectory/tmp/$($release.tag_name).zip" -DestinationPath "$releaseDirectory/tmp/extracted"
      $extractedSubFolder = Get-ChildItem -Path "$releaseDirectory/tmp/extracted" -Directory

      if ($null -ne $directoryAndFilesToKeep) {
        foreach ($path in $directoryAndFilesToKeep) {
          Write-Host ""
          Write-Host "===> Moving $path into $releaseDirectory." -ForegroundColor Cyan


          Move-Item -Path "$($extractedSubFolder.FullName)/$($path)" -Destination "$releaseDirectory" -ErrorAction SilentlyContinue
        }
      }

      if ($null -eq $directoryAndFilesToKeep) {
        Write-Host ""
        Write-Host "===> Moving all extracted contents into $releaseDirectory." -ForegroundColor Cyan
        Move-Item -Path "$($extractedSubFolder.FullName)/*" -Destination "$releaseDirectory" -ErrorAction SilentlyContinue
      }

      Remove-Item -Path "$releaseDirectory/tmp" -Force -Recurse

    }
    else {
      Write-Host ""
      Write-Host "===> Content already exists in $releaseDirectory. Skipping" -ForegroundColor Yellow
    }
  }
}

if ($syncAllReleases -eq $false) {
  Write-Host ""
  Write-Host "=====> Syncing latest release $($latestRepoRelease.tag_name) only of $repoOrgPlusRepo into $directoryForReleases" -ForegroundColor Cyan

  $releaseDirectory = "$directoryForReleases/$($latestRepoRelease.tag_name)"

  Write-Host ""
  Write-Host "===> Checking if directory for release version exists: $releaseDirectory" -ForegroundColor Cyan

  if (!(Test-Path $releaseDirectory)) {
    Write-Host ""
    Write-Host "Directory does not exist for release $($latestRepoRelease.tag_name), will now create: $releaseDirectory" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $releaseDirectory
  }

  Write-Host ""
  Write-Host "===> Checking if any content exists inside of $releaseDirectory" -ForegroundColor Cyan

  $contentInReleaseDirectory = Get-ChildItem -Path $releaseDirectory -Recurse -ErrorAction SilentlyContinue

  if ($null -eq $contentInReleaseDirectory) {
    Write-Host ""
    Write-Host "===> Pulling and extracting release $($latestRepoRelease.tag_name) into $releaseDirectory" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path "$releaseDirectory/tmp"
    Invoke-WebRequest -Uri "https://github.com/$repoOrgPlusRepo/archive/refs/tags/$($latestRepoRelease.tag_name).zip" -OutFile "$releaseDirectory/tmp/$($latestRepoRelease.tag_name).zip"
    Expand-Archive -Path "$releaseDirectory/tmp/$($latestRepoRelease.tag_name).zip" -DestinationPath "$releaseDirectory/tmp/extracted"
    $extractedSubFolder = Get-ChildItem -Path "$releaseDirectory/tmp/extracted" -Directory

    if ($null -ne $directoryAndFilesToKeep) {
      foreach ($path in $directoryAndFilesToKeep) {
        Write-Host ""
        Write-Host "===> Moving $path into $releaseDirectory." -ForegroundColor Cyan
        Move-Item -Path "$($extractedSubFolder.FullName)/$($path)" -Destination "$releaseDirectory" #-ErrorAction SilentlyContinue
      }
    }

    if ($null -eq $directoryAndFilesToKeep) {
      Write-Host ""
      Write-Host "===> Moving all extracted contents into $releaseDirectory." -ForegroundColor Cyan
      Move-Item -Path "$($extractedSubFolder.FullName)/*" -Destination "$releaseDirectory" -ErrorAction SilentlyContinue
    }

    Remove-Item -Path "$releaseDirectory/tmp" -Force -Recurse

  }
  else {
    Write-Host ""
    Write-Host "===> Content already exists in $releaseDirectory. Skipping" -ForegroundColor Yellow
  }
}

# Stop timer
$StopWatch.Stop()

# Display timer output as table
Write-Host "Time taken to complete task:" -ForegroundColor Yellow
$StopWatch.Elapsed | Format-Table
