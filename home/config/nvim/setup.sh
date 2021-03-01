#!/bin/sh
# If the operating system is not NixOS, do nothing
# If it is any other, then curl vim-plug into the plugin directories,
# depending on if vim or neovim is present.

command -v vim 1> /dev/null && vim_path="$HOME/.vim/autoload/"
command -v nvim 1> /dev/null && \ 
    nvim_path="${XDG_DATA_HOME:-$HOME/.local/share/}/nvim/site/autoload/"

if command -v nixos-version 1> /dev/null ; then
    true
else
    for p in $vim_path $nvim_path; do
        mkdir -p "$p" && curl -fLo "${p}plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    done
fi
