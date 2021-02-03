$galleryStatus = Get-PSRepository -Name "PSGallery"
if ($galleryStatus.InstallationPollicy -ne "Trusted") {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
# https://github.com/dahlbyk/posh-git
Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force
# https://github.com/JanDeDobbeleer/oh-my-posh
Install-Module oh-my-posh -Scope CurrentUser -AllowPrerelease -Force

Write-Host "Remember to install a font such as Caskaydia Cove NF from https://www.nerdfonts.com/font-downloads" -ForegroundColor Yellow
