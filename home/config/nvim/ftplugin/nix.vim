" For nix files.
autocmd BufEnter $HOME/code/etc/nixos/* setlocal makeprg=sudo\ nixos-rebuild\ dry-activate
