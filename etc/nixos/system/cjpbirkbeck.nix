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
  '' else
  ''
    Xserver:   Disabled
  '');

  security = {
    doas = {
      enable = true;

      extraRules = [
        {
          groups = [ "wheel" ];
          persist = true;
          keepEnv = true;
        }
        # {
        #   groups = [ "wheel" ];
        #   cmd = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
        #   setEnv = [ "NIX_CONFIG" ];
        # }
      ];
    };
  };

  # Define my basic user details.
  users = {
    groups = {
      doas = { };
    };
    users.cjpbirkbeck = {
      description = "Christopher Birkbeck";
      isNormalUser = true;
      extraGroups = [ "wheel" "lp" "scanner" "networkmanager" "vboxusers" ];
    };
  };
}
