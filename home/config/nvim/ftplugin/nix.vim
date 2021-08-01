" For nix files.
autocmd BufEnter $HOME/code/etc/nixos/* setlocal makeprg=sudo\ nixos-rebuild\ dry-activate

iabbrev ;;[ [];<Left><Left>
iabbrev ;;b [];<Left><Left>
iabbrev ;;{ {};<Left><Left>
iabbrev ;;B {};<Left><Left>
iabbrev ;;p with pkgs;
