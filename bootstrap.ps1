function Add-Symlink ($from, $to) {
    New-Item -ItemType SymbolicLink -Path $from -Target $to -Force
}

Write-Host "This script will override some of your home files"
Write-Host "If you are okay with that complete the sentence below, ALL CAPS please..." -ForegroundColor Red
$Answer = Read-Host -Prompt "LEEEEEEROOOY"

if ($Answer -ne "JENKINS") {
    Write-Host "At least you have chicken. I guess..."
    return -1;
}

Write-Host "Replacing .gitconfig"
Add-Symlink "${HOME}\.gitconfig" "${PSScriptRoot}\.gitconfig"

Write-Host "Replacing Powershell Profile"
Add-Symlink "${PROFILE}" "${PSScriptRoot}\powershell\Microsoft.PowerShell_profile.ps1"

Write-Host "If this is a really fresh install run install_softwares.ps1 to get going" -ForegroundColor Yellow
Write-Host "Done!" -ForegroundColor Green