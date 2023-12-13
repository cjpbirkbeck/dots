{ config, pkgs, ... }:

{
  users.motd = with config; ''
    Welcome to ${networking.hostName}!

    * This machine is managed by NixOS.
    * Well, I do declare this to be a mighty fine configutation!

    OS:        NixOS ${system.nixos.release} (${system.nixos.codeName})
    Version:   ${system.nixos.version}
    Kernel:    ${boot.kernelPackages.kernel.version}
    Locale:    ${i18n.defaultLocale}
    Time Zone: ${time.timeZone}
  '' + (if services.xserver.enable then
  ''
    Xserver:   Enabled
  ''
    else
  ''
    Xserver:   Disabled
  '');

  # security = {
  #   doas = {
  #     enable = true;

  #     extraRules = [
  #       {
  #         groups = [ "wheel" ];
  #         persist = true;
  #       }
  #       {
  #         users = [ "cjpbirkbeck" ];
  #         cmd = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
  #         persist = true;
  #         setEnv = [ "NIX_CONFIG" ];
  #       }
  #     ];
  #   };
  # };

  # Define my basic user details.
  users = {
    groups = {
      doas = {
        members = [ "cjpbirkbeck" ];
      };
      vboxusers = {
        members = [ "cjpbirkbeck" ];
      };
    };
    users.cjpbirkbeck = {
      description = "Christopher Birkbeck";
      isNormalUser = true;
      extraGroups = [ "input" "wheel" "lp" "scanner" "networkmanager" "vboxusers" ];
    };
  };
}
