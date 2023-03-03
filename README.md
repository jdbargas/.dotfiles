# dotfiles

custom config files (.zshrc, .vimrc, etc)  
personal collection of dotfiles and zsh/vim plugins with script to deploy them

**REQUIREMENTS:** [oh-my-zsh](https://ohmyz.sh/) is installed and `$ZSH` points to `.oh-my-zsh` installation folder

custom `.zshrc` and `.vimrc`

`vim` plugins handled by [vim-plug](https://github.com/junegunn/vim-plug) and listed in PLUGINS section of `.vimrc`

`zsh` plugins are maintained as git submodules and linked to
`$ZSH/custom/plugins/`

`zsh` themes are maintained in zsh/themes and linked to `$ZSH/custom/themes/`

run `./linkdotfiles` to view affected files/folders  
run `./linkdotfiles force` to link and/or move files 
