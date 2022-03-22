# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Enables Deno on the shell
if [ -d "$DENO_INSTALL/bin" ] ; then
    export PATH="$DENO_INSTALL/bin:$PATH"
    PATH="$HOME/.local/bin:$PATH"
fi

# Sets PROJ_DIR environment variable
export PROJ_DIR="$HOME/projects/"

# Sets DOTFILES_DIR environment variable
export DOTFILES_DIR="$HOME/projects/dotfiles"

# Setting up navigation aliases
alias gtp="pushd $PROJ_DIR"
alias push="pushd"
alias back="popd"
alias gtd="pushd $DOTFILES_DIR"

# Setting up QoL aliases
alias profile-edit="code ~/.profile"

# Setting up git aliases
alias gfpull="git fetch --all; git pull"
alias gfrebase="git fetch --all; git rebase -i"
alias gup="git push -u origin HEAD"
