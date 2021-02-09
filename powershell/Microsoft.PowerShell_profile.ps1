# Grabbing run settings from env variables
[bool]$RunEnvCheck = ($null -eq $env:PWSH_SKIP_ENV_CHECK)
[bool]$EnableAutoComplete = ($null -eq $env:PWSH_SKIP_AUTOCOMPLETE)
[string]$GitSshConfig = $env:GIT_SSH ?? ""
[string]$DotFilesSrc = $env:DOTFILES_DIR ?? ($null -ne $env:PROJ_DIR ? "${env:PROJ_DIR}\dotfiles" : "")

# All Shortcuts
Set-Alias -Name "back" -Value Pop-Location
Set-Alias -Name "push" -Value Push-Location
Set-Alias -Name "touch" -Value New-Item
Set-Alias -Name "open" -Value Invoke-Item
Set-Alias -Name "gfpull" -Value Invoke-Git-FetchAndPull
Set-Alias -Name "gfrebase" -Value Invoke-Git-FetchAndRebase
Set-Alias -Name "gpruneb" -Value Invoke-Git-PruneGoneBranches
Set-Alias -Name "gcleanup" -Value Invoke-Git-Cleanup
Set-Alias -Name "greset" -Value Invoke-GitResetClean
Set-Alias -Name "gtp" -Value Push-Projects-Dir
Set-Alias -Name "keygen" -Value New-SshKey
Set-Alias -Name "code-export" -Value Export-VSCodeExtensionsToTxt
Set-Alias -Name "code-import" -Value Import-VSCodeExtensionsFromTxt
Set-Alias -Name "dupdate" -Value Update-DotFiles
Set-Alias -Name "gtd" -Value Push-DotfilesDir
Set-Alias -Name "profile-edit" -Value Invoke-EditPwshProfile

<#
.SYNOPSIS
    Calls fetches and pulls updates from the upstream branch. Stashes and Pops if there are uncomitted changes
.DESCRIPTION
    Shortcut function for calling git fetch and git pull while keeping uncomitted changes
#>
function Invoke-Git-FetchAndPull {
    git fetch --all
    git diff --exit-code
    $hasDiff = $LASTEXITCODE
    if ($hasDiff) {
        git stash
    }
    git pull
    if ($hasDiff) {
        git stash pop
    }
}

<#
.SYNOPSIS
    Calls fetch and then rebases into the target branch
.DESCRIPTION
    Shortcut function for calling git fetch and git rebase -i
.PARAMETER TargetBranch
    The branch to rebase on, defaults to origin/develop
#>
Function Invoke-Git-FetchAndRebase {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "The branch to rebase on, defaults to origin/develop")]
        [string]
        $TargetBranch = "origin/develop"
    )
    git fetch --all
    git rebase -i $TargetBranch
}

<#
.SYNOPSIS
    Prunes and deletes branches that were removed from the remote
.DESCRIPTION
    Shortcut function for deleting branches that are gone from the remote
#>
Function Invoke-Git-PruneGoneBranches() {
    Invoke-Git-FetchAndPull
    git branch --v |
    Where-Object { $_ -match "\[gone\]" } |
    ForEach-Object { -split $_ | Select-Object -First 1 }
    | ForEach-Object { git branch -D $_ }
}

<#
.SYNOPSIS
    Prunes and runs git garbage collection
.DESCRIPTION
    Shortcut function to call upon git prune and git gc
#>
Function Invoke-Git-Cleanup() {
    git remote prune origin
    git prune origin
    git gc
}

<#
.SYNOPSIS
    Resets the working directory to the last commit, also drops untracked files
.DESCRIPTION
    Shortcut function to call upon git reset --hard and git clean
#>
function Invoke-GitResetClean {
    Write-Warning "Resetting changes on the local directory"
    git reset --hard
    git clean -qfd
}

<#
.SYNOPSIS
    Navigates into the projects' directory
#>
Function Push-Projects-Dir {
    if ($env:PROJ_DIR) {
        Push-Location $env:PROJ_DIR
        return;
    }

    Write-Warning "Unable to navigate, no project directory is set"
    Write-Warning "Setup the env:PROJ_DIR variable with a valid directory"
}

<#
.SYNOPSIS
    Creates a new SSH key and stores it on ~/.ssh
.DESCRIPTION
    Creates a new ED25519 ssh key with a comment.
.PARAMETER Comment
    The SSH's key comment, usually an email address or hostname.
#>
function New-SshKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $Comment
    )
    ssh-keygen -o -a 100 -t ed25519 -C $Comment
}

<#
.SYNOPSIS
    Exports VSCode extensions to the dotfiles directory
.DESCRIPTION
    Stores the VSCode extensions on a .txt on the current dotfiles directory, so it can be restored later
.PARAMETER Target
    Current dotfiles directory, defaults to either the env's DOTFILES_DIR or a composition of PROJ_DIR + dotfiles
#>
function Export-VSCodeExtensionsToTxt {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        # Directory to store the extensions.txt file
        $Target = $DotFilesSrc
    )

    try {
        &code --list-extensions |
        Out-File "${Target}\vscode\extensions.txt"
    }
    catch {
        Write-Warning "Unable to recover VSCode's extensions, is it installed?"
    }
}

<#
.SYNOPSIS
    Installs VSCode extensions for the dotfiles directory
.DESCRIPTION
    Restores the VSCode extensions from the .txt on the current dotfiles directory
.PARAMETER Source
    Current dotfiles directory, defaults to either the env's DOTFILES_DIR or a composition of PROJ_DIR + dotfiles
#>
function Import-VSCodeExtensionsFromTxt {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        # Directory containing extensions.txt file
        $Source = $DotFilesSrc
    )

    try {
        Get-Content "${Source}\vscode\extensions.txt" |
        ForEach-Object -Process {
            &code --install-extension $_
        }
    }
    catch {
        Write-Warning "Unable to restore VSCode's extensions, is it installed?"
    }
}

<#
.SYNOPSIS
    Updates the current dotfiles settings
.DESCRIPTION
    Shortcut function to update the dotfiles for this computer thru git
.PARAMETER Target
    Directory with the current dotfiles, defaults to either the env's DOTFILES_DIR or a composition of PROJ_DIR + dotfiles
#>
function Update-DotFiles {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Target = $DotFilesSrc
    )

    Push-Location $Target
    Invoke-Git-FetchAndPull
    Pop-Location
}

<#
.SYNOPSIS
    Navigates into the dotfiles' directory
#>
function Push-DotfilesDir {
    if ($DotFilesSrc) {
        Push-Location $DotFilesSrc
        return;
    }

    Write-Warning "Unable to navigate, no dotfiles directory is set"
    Write-Warning "Setup the env:DOTFILES_DIR or the env:PROJ_DIR variable with a valid directory"
}

<#
.SYNOPSIS
    Opens up the $PROFILE directory in VS Code.
#>
function Invoke-EditPwshProfile {
    code (Get-Item $PROFILE).Directory    
}

# Attempt to load PSReadLine
try {
    Import-Module PSReadLine
}
catch {
    Write-Error "Unable to Import-Module PSReadLine, it wasn't found"
}

# Attempt to load posh-git
try {
    Import-Module posh-git
}
catch {
    Write-Error "Unable to Import-Module posh-git, it wasn't found"
}

# Attempt to load oh-my-posh
try {
    Import-Module oh-my-posh
    Set-PoshPrompt Paradox
}
catch {
    Write-Error "Unable to Import-Module oh-my-posh, it wasn't found"
}

# Setup Autocomplete for some commands
if ($EnableAutoComplete) {
    # src: https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
    # PowerShell parameter completion shim for the dotnet CLI
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }

    # src: https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
    # Registers AutoCompletion for WinGet
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

# Environment Checks
if ($RunEnvCheck) {
    # Warns user if the PROJ_DIR environment variable isn't set
    # if its there it also attempts to check if it exists and creates a new directory if possible
    if (!($env:PROJ_DIR)) {
        Write-Warning "Project Directory (PROJ_DIR) isn't set, some functions might fail"
        try {
            Get-Item $env:PROJ_DIR -ErrorAction Stop
        }
        catch {
            Write-Warning "Project Directory is set but doesn't exist"
        }
    }

    # Checks if git is available
    try {
        Get-Command git -ErrorAction Stop > $null
    }
    catch {
        Write-Warning "Git isn't available"
    }

    # Checks if code is available
    try {
        Get-Command code -ErrorAction Stop > $null
    }
    catch {
        Write-Warning "VSCode isn't available"
    }

    # Checks if CaskaydiaCove NF is available
    try {
        Get-Item "${env:windir}\Fonts\Caskaydia Cove*" -ErrorAction Stop > $null
    }
    catch {
        Write-Warning "CaskaydiaCove NerdFont isn't available"
    }

    # Checks if there is a .ssh folder on ~
    try {
        Get-Item "${HOME}\.ssh" -ErrorAction Stop > $null
    }
    catch {
        Write-Warning "There are no ssh keys available"
    }

    # Checks if SSH Agent is running and git is configured
    try {
        $sshAgentStatus = (Get-Service -Name "ssh-agent").Status
        if ($sshAgentStatus -ne "Running") {
            Write-Warning "ssh-agent isn't running, you should change its initialization"
        }
        if ($null -eq $GitSshConfig) {
            Write-Warning "GIT_SSH isn't set, it might not use windows' OpenSSH"
        }
    }
    catch {
        Write-Warning "Unable to check on ssh-agent status"
    }

    if (!$DotFilesSrc) {
        Write-Warning "Unable to find where you're storing your dotfiles, either set a DOTFILES_DIR environment variable or create a dotfiles under your PROJ_DIR"
    }
}

# Attempting to load extras
if (Test-Path "${PSScriptRoot}\extras.ps1" -PathType Leaf) {
    . "${PSScriptRoot}\extras.ps1"
}
