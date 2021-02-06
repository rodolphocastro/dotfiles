# Rodolpho Alves' dotFiles

## What are dotfiles

In a nutshell:

> Basically this is an old-school way to OneDrive/Google Sync/Dropbox your settings. At least those that are *easy to automate*.

A `dotfiles` repository is an attempt to keep multiple settings in-sync across multiple environments **without relying on external solutions.** Basically once you have this repository done all you gotta do is `git clone` it into a new environment and run the `bootstrap` script.

The biggest challenge for *this* set of `dotfiles` is to deal with the Windows' way of setting stuff up. Thus why you'll notice some powershell wizardry going on. Things like what I'm trying to achieve here are way easier on `nix` environments.

> But the challenge of doing this on Windows is exactly what fuels me 😎

If you're interested in the subject you might want to check out some articles such as:

1. https://dotfiles.github.io/
2. https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789

## How to use this?

**First and foremost**:

> **Do not use this if you have no idea what these scripts are doing**. Never run scripts blindly, especially those found on the internet.


### Windows

If you're on Windows:

1. Download this repository or Clone it with `git`
2. Run the `bootstrap.ps1` file
3. **Answer the ultra-secret totally not related to WoW question 🐔**
4. ???
5. Profit 💲💲💲

This will set you up with some VSCode settings, Windows Terminal and Powershell settings.

If you're not me (lol) you might want to **change your ~/.gitconfig** so you won't commit stuff using my name.

#### Expanding on the Profile

If you need more stuff on your profile but doesn't want to track it you can **expand upon the current Profile by creating an `extras.ps1` file on the same directory your Profile's on**.

Usually this means you'll create an `extras.ps1` file on `${HOME}\Documents\PowerShell\`.

#### Installing stuff

The `bootstrap` script doesn't install anything for you. If you're interested in install stuff you'll need to run the following scripts:

1. `install_softwares.ps1`: Sets you up with a bunch of development tools
2. `powershell/setup/install_pwsh_modules.ps1`: Sets you up with a bunch of Powershell Modules

### Linux

> WIP, eventually I'll add my WSL goodies here

## Directory structure

This is the directory structure I'll be keeping for my `dotfiles`:

| Directory      | What goes into it                |
| -------------- | -------------------------------- |
| `.`            | Everything that goes to `~`      |
| `./powershell` | Powershell Profiles and Snippets |
| `./terminal`   | Everything Windows Terminal      |
| `./vscode`     | VisualStudio Code goodies        |

## Environment variables

Those are some environment variables that are used throughout my scripts/profiles:

| Name                     | What it affects                                                                      |
| ------------------------ | ------------------------------------------------------------------------------------ |
| `PWSH_SKIP_ENV_CHECK`    | if this is set to anything the `$PROFILE` will skip checking the Environment's Setup |
| `PWSH_SKIP_AUTOCOMPLETE` | If this is set we won't setup Autocompletion for Powershell on `$PROFILE`            |
| `PROJ_DIR`               | This should point to a directory where you keep most of your source codes            |
| `DOTFILES_DIR`           | This should point to where you keep this repository's files                          |
