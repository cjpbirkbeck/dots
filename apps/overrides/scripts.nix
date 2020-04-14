# Miscellaneous scripts that should available to all users.

{ pkgs, config, ... }:

let
  nixos-rebuild-wrapper = pkgs.writeScriptBin "nixos" ''
    #!${pkgs.stdenv.shell}

    while [ "$#" -gt 0 ]; do
        case "$1" in
            "-l"|"--label")
                shift
                NIXOS_LABEL_VERSION=$(echo "$1" | sed -e 's/ /_/g')
                export NIXOS_LABEL_VERSION
                shift
                ;;
            "switch"|"boot"|"build"|"dry-build"|"dry-activate"|"build-vm"|"build-vm-with-bootloader")
                nixos-rebuild "$@"
                exit
                ;;
            "edit")
                $EDITOR /etc/nixos/configuration.nix
                exit
                ;;
            "option")
                nixos-option "$@"
                exit
                ;;
            "version"|"-v")
                nixos-version "$@"
                exit
                ;;
            *)
                exit 10
                ;;
        esac
    done
  '';
in {
  environment.systemPackages = [ nixos-rebuild-wrapper ];
}
