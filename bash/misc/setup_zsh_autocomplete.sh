#!/bin/bash

# Clone ZSH Completions into ZSH's custom repo
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# Add these lines to .zsh
# plugins=(… zsh-completions)
# autoload -U compinit && compinit