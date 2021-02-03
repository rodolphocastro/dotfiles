<#
.SYNOPSIS
    Checks if a Command is currently available on Powershell
#>
function Test-CommandExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$testCommand
    )
    
    try {
        Get-Command $testCommand -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

if (!(Test-CommandExists winget)) {
    Write-Host "Winget not found, unable to continue"
    Write-Host "Check on https://github.com/microsoft/winget-cli for instructions"
    return -1
}

# TODO: Replace search with install

&winget search -e --id Microsoft.PowerShell

&winget search -e --id Git.Git

&winget search -e --id Microsoft.WindowsTerminal

&winget search -e --id Microsoft.VisualStudioCode-User-x64

&winget search -e --id Microsoft.dotnet