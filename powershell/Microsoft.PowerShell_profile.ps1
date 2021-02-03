# Utilit�rios
function Push-Project-Dir() {
    Push-Location $env:PROJ_DIR
}
Set-Alias gtp Push-Project-Dir

## Gerar uma chave SSH segura
function Build-New-SSH-Key {
    param (
        $Comment
    )
    ssh-keygen -o -a 100 -t ed25519 -C $Comment
}

## Alias para Pop-Localtion
Set-Alias back Pop-Location

## Alias para o New-Item, equivalente ao touch
Set-Alias touch New-Item

# Git fetch --all e pull
function Git-Fetch-And-Pull {
    git fetch --all; git pull
}
Set-Alias -Name gfpull -Value Git-Fetch-And-Pull

# Git fetch --all e rebase, em um branch
function Git-Fetch-And-Rebase { 
    param (
        $TargetBranch = "origin/develop"
    )
    git fetch --all; git rebase -i $TargetBranch
}
Set-Alias -Name gfrebase -Value Git-Fetch-And-Rebase

# Inicializando o Oh-My-Posh
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

# Verificando se o ambiente está devidamente configurado
if(!$env:PROJ_DIR){
    Write-Warning "A variável de ambientes PROJ_DIR não está configurada"
}

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