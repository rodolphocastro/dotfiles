<#
.SYNOPSIS
    Creates a Symlink between two files
.DESCRIPTION
    Creates a symlink between two files on windows
#>
function Add-Symlink {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$from,
        [Parameter(Mandatory)]
        [string]$to
    )

    New-Item -ItemType SymbolicLink -Path $from -Target $to -Force
}

Write-Warning "This script will override some of your home files"
Write-Warning "If you are okay with that complete the sentence below, ALL CAPS please..."
$Answer = Read-Host -Prompt "LEEEEEEROOOY"

if ($Answer -ne "JENKINS") {
    Write-Host "At least you have chicken. I guess..."
    return -1;
}

Write-Output "Replacing .gitconfig"
Add-Symlink "${HOME}\.gitconfig" "${PSScriptRoot}\.gitconfig" > $null
Write-Output "Replacing .gitignore"
Add-Symlink "${HOME}\.gitignore" "${PSScriptRoot}\.gitignore" > $null

Write-Output "Replacing Powershell Profile"
Add-Symlink "${PROFILE}" "${PSScriptRoot}\powershell\Microsoft.PowerShell_profile.ps1" > $null

Write-Output "Attempting to Replace Windows Terminal settings"
$StorePackages = "${HOME}\AppData\Local\Packaaaages\*Microsoft.WindowsTerminal*"
$WindowsTerminalDir = Get-ChildItem $StorePackages -ErrorAction SilentlyContinue
if ($WindowsTerminalDir) {
    Write-Output "Found WindowsTerminal on ${WindowsTerminalDir}, creating symlink"
    Add-Symlink "${WindowsTerminalDir}\LocalState\settings.json" "${PSScriptRoot}\terminal\settings.json" > $null
}

Write-Output "Attempting to Replace VSCode settings"
$VSCodeDir = "${HOME}\AppData\Roaming\Code"
if (Get-ChildItem $VSCodeDir -ErrorAction SilentlyContinue) {
    Write-Output "Found VSCode on User's AppData, creating symlink"
    Add-Symlink "${VSCodeDir}\User\settings.json" "${PSScriptRoot}\vscode\settings.json"  > $null
    Add-Symlink "${VSCodeDir}\User\keybindings.json" "${PSScriptRoot}\vscode\keybindings.json"  > $null
    # Clear snippets before attempting to link
    Get-Item "${VSCodeDir}\User\snippets\" -ErrorAction SilentlyContinue |
    Remove-Item -Force -Recurse
    Add-Symlink "${VSCodeDir}\User\snippets\" "${PSScriptRoot}\vscode\snippets\" > $null
}

Write-Warning "If you see Powershell Profile errors you'll want to run ./powershell/setup/install_pwsh_modules.ps1 as well"
Write-Output "If this is a really fresh install run install_softwares.ps1 to get going"
Write-Output "Done!"
