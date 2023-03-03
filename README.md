# dotfiles

custom config files (.zshrc, .vimrc, etc)  
personal collection of dotfiles, plugins, and themes with script to deploy them

## Requirements

`zsh` is default shell  
[oh-my-zsh](https://ohmyz.sh/) is installed and `$ZSH` points to `.oh-my-zsh` installation folder  
`vim --version` >= 9.0 

## Overview

custom `.zshrc` and `.vimrc`

`vim` plugins handled by [vim-plug](https://github.com/junegunn/vim-plug) in `.vimrc`  
`zsh` plugins are maintained as git submodules and linked to
`$ZSH/custom/plugins/`  
`zsh` themes are maintained in zsh/themes and linked to `$ZSH/custom/themes/`

## Installation

run `./linkdotfiles` to view affected files/folders  
run `./linkdotfiles force` to link files/folders
