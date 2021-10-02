#!/bin/bash

# Ensure latest packages are fetched
sudo apt update

# Install zsh
sudo apt install git zsh -y

# Invoke oh-my-zsh install script
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"