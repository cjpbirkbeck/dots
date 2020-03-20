# Miscellaneous scripts that should available to all users.

{ pkgs, config, ... }:

let
  nixos-upgrade = pkgs.writeScriptBin "nixos-upgrade" ''
    #!${pkgs.stdenv.shell}

    if [ $UID -ne 0 ]; then
       echo "Operations must be done by root user."
       exit 1
    fi

    nixos-rebuild switch --upgrade && \
    nix-collect-garbage --delete-older-than 14d && \
    nix optimise-store && \
    mandb --create
    '';
in {
  environment.systemPackages = [ nixos-upgrade ];
}
