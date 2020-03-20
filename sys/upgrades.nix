# Programs and setting use to update and upgrade the system.

{ config, pkgs, ... }:

let
  nixos-upgrade = pkgs.writeScriptBin "nixos-upgrade" ''
    #!${pkgs.stdenv.shell}

    if [ $UID -ne 0 ]; then
       echo "Operations must be done by root user."
       exit 1
    fi

    if [ $1 != "switch" ] || [ $1 != "boot" ] || [ $1 != "test" ] ||
       [ $1 != "build" ]  || [ $1 != "build-vm"] ||
       [ $1 != "build-vm-with-bootloader" ]; then
       echo "Need to specify upgrade action."
       exit 2
    fi

    if [ -n $2 ]; then
       export NIXOS_LABEL="$(echo $2 | sed -E 's/\s/_/g')"
    fi

    nixos-rebuild $1 --upgrade
  '';

  nixos-full-upgrade = pkgs.writeScriptBin "nixos-full-upgrade" ''
    #!${pkgs.stdenv.shell}

    nixos-upgrade $1 $2  && \
    nix-collect-garbage --delete-older-than 15d && \
    nix optimise-store && \
    mandb --create
  '';

  nixos-estimate = pkgs.writeScriptBin "nixos-estimate" ''
    #!${pkgs.stdenv.shell}

    nixos dry-run --upgrade > $NIXOS_ESTIMATE
  '';
in {
  nix = {
    gc = {
      automatic = true;
      dates = "23:00";
      options = "--delete-older-than 15d";
    };

    optimise = {
      automatic = true;
      dates = [ "23:05" ];
    };
  };

  environment = {
    # systemPackages = [ nixos-upgrade nixos-full-upgrade nixos-upgrade ];
  };
}
