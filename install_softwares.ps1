function Test-CommandExists {
    param (
        $testCommand
    )
    try {
        Get-Command $testCommand -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Appends something to $PROFILE
function Add-To-Profile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $sourceFile
    )
    $fileContent = Get-Content $sourceFile
    Add-Content $PROFILE "`n"
    Add-Content $PROFILE -Value $fileContent
}

if (!(Test-CommandExists winget)) {
    Write-Host "Winget not found, unable to continue"
    Write-Host "Check on https://github.com/microsoft/winget-cli for instructions"
    return -1
}

# TODO: Replace search with install

# Setup winget autocomplete
Add-To-Profile ".\pwsh_setup\winget_autocomplete.ps1"

&winget search -e --id Git.Git

&winget search -e --id Microsoft.PowerShell

&winget search -e --id Microsoft.WindowsTerminal

&winget search -e --id Microsoft.VisualStudioCode-User-x64

&winget search -e --id Microsoft.dotnet

# Setup dotnet autocomplete
Add-To-Profile ".\pwsh_setup\dotnet_autocomplete.ps1"