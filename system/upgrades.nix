# Programs and setting use to update and upgrade the system.

{ config, pkgs, ... }:

let
  # My customized upgrade script, which will upgrade the system.
  # Then preform miscellaneous system administration tasks after.
  auto-nixos-upgrade = pkgs.writeScriptBin "auto-nixos-upgrade" ''
    #!${pkgs.stdenv.shell}

    NIXOS_LABEL_VERSION="Automatic_upgrade-on-$(date '+%H%M%z')"

    ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch --upgrade || exit 1
    ${config.nix.package.out}/bin/nix-collect-garbage --delete-older-than 14d
    ${config.nix.package.out}/bin/nix optimise-store
    # mandb --create
  '';

  name = config.networking.hostName;
in {
  # nix = {
  #   gc = {
  #     automatic = true;
  #     dates = "23:00";
  #     options = "--delete-older-than 15d";
  #   };

  #   optimise = {
  #     automatic = true;
  #     dates = [ "23:05" ];
  #   };
  # };

  systemd = {
    services = {
      auto-upgrades = {
        description = "Customized System Upgrade";
        script = "exec ${auto-nixos-upgrade}/bin/auto-nixos-upgrade";
        environment = config.nix.envVars //
          { inherit (config.environment.sessionVariables) NIX_PATH;
            HOME = "/root";
          } // config.networking.proxy.envVars;path = with pkgs; [ coreutils gnutar xz.bin gzip gitMinimal config.nix.package.out ];
        startAt = (if name == "archimedes" then "22:00" else "23:00");
      };
    };
  };

  environment = {
    # systemPackages = [ nixos-upgrade nixos-full-upgrade nixos-upgrade ];
  };
}
