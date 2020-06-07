#!/bin/sh
# If the operating system is not NixOS, get 

if command -v nixos-version 1> /dev/null ; then
    true
else
    command -v vim 1> /dev/null && vim_path="$HOME/.vim/"
    command -v nvim 1> /dev/null && nvim_path="$HOME/.config/nvim/"

    for p in $vim_path $nvim_path; do
        mkdir -p "$p" && curl -fLo "${p}plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    done
fi
