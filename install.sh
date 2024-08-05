#!/usr/bin/env bash
# ┏┓ ╻  ┏━┓┏━╸╻┏ ┏━┓╺┳┓┏━╸
# ┣┻┓┃  ┣━┫┃  ┣┻┓┣━┫ ┃┃┣╸ 
# ┗━┛┗━╸╹ ╹┗━╸╹ ╹╹ ╹╺┻┛┗━╸
# Blackade's dotfiles. Under MIT License.
# Install script

# default install
cli_default=(
    'neovim'
    'pluton'
    'zsh'
)
gui_default=(
    'fontconfig'
)

# install dotfiles
for dotfile in ${cli_default[@]} $(false && echo ${gui_default[@]}); do
    echo installing $dotfile
    stow -S $dotfile
done

# install plugins
~/.local/bin/pluton
