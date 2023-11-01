[CmdletBinding()]
param (
  [Parameter(Mandatory = $false)]
  [string]
  $versionFilePath = "./version.json"
)

Describe "version.json file tests" {

  Context "version.json file tests" {

    BeforeAll {
      $versionFile = Get-Content $versionFilePath -Raw | ConvertFrom-Json
      $gitRepoLatestTag = git describe --tags --abbrev=0
      $releaseNotesUrlSplitLast = $versionFile.releaseNotes.Split("/")[-1]
      $releaseNotesUrlStart = "https://github.com/Azure/alz-bicep/releases/tag/v"

      # Download the previous version.json file from the repo
      $previousVersionRawUrl = "https://raw.githubusercontent.com/Azure/alz-bicep/$gitRepoLatestTag/version.json"
      $previousVersionOutputFile = "./previousVersion.json"
      Invoke-WebRequest -Uri $previousVersionRawUrl -OutFile $previousVersionOutputFile
      $PreviousVersionFile = Get-Content $previousVersionOutputFile -Raw | ConvertFrom-Json
    }

    It "version.json file exists" {
      $versionFile | Should -Not -BeNullOrEmpty
    }

    It "version.json file contains the required properties" {
      $versionFile.version | Should -Not -BeNullOrEmpty
      $versionFile.gitTag | Should -Not -BeNullOrEmpty
      $versionFile.releaseNotes | Should -Not -BeNullOrEmpty
      $versionFile.releaseDateTimeUTC | Should -Not -BeNullOrEmpty
    }

    It "version.json file version property has been updated and increased from the latest git tag" {
      $versionFile.version | Should -BeGreaterThan $PreviousVersionFile.version
    }

    It "version.json file gitTag property has been updated and increased from the latest git tag" {
      $versionFile.gitTag | Should -BeGreaterThan $PreviousVersionFile.gitTag
    }

    It "version.json file releaseNotes property has been updated and URL last split on / does not match the latest git tag" {
      $releaseNotesUrlSplitLast | Should -Not -Be $gitRepoLatestTag
    }

    It "version.json file releaseNotes property is a valid URL and has the correct format" {
      $versionFile.releaseNotes | Should -BeLike "$releaseNotesUrlStart*"
    }

    It "version.json file releaseDateTimeUTC property has been updated and UTC time/date stamp if newer than the last value" {
      $versionFile.releaseDateTimeUTC | Should -BeGreaterThan $PreviousVersionFile.releaseDateTimeUTC
    }

  }
}
