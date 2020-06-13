" For nix files.
autocmd BufEnter $HOME/Code/nixos/* setlocal makeprg=sudo\ nixos-rebuild\ dry-activate
