{ config, pkgs, ... }:

{
users.motd = with config; ''
[?7l[1m[34m  \\  \\ //     [38;5;9mOS[0m           NixOS ${system.nixos.release} (${system.nixos.codeName})
[1m[34m[34m ==\\__\\/ //   [38;5;9mVersion[0m      Linux ${system.nixos.version}
[1m[34m[34m   //   \\//    [38;5;9mKernel[0m       ${boot.kernelPackages.kernel.version}
[1m[34m[34m==//     //==   [38;5;9mLocale[0m       ${i18n.defaultLocale}
[1m[34m[34m //\\___//      [38;5;9mTime Zone[0m    ${i18n.defaultLocale}
[1m[34m[34m// /\\  \\==    [38;5;9mLogin Shells[0m bash ${pkgs.bashInteractive.version}, zsh ${pkgs.zsh.version}
[1m[34m[34m  // \\  \\     [0m       

[?7h
'';

  # users.motd = with config; ''
  #   Welcome to ${networking.hostName}!
  #
  #   * This machine is managed by NixOS.
  #   * Well, I do declare this to be a mighty fine configutation!
  #
  #   OS:        NixOS ${system.nixos.release} (${system.nixos.codeName})
  #   Version:   ${system.nixos.version}
  #   Kernel:    ${boot.kernelPackages.kernel.version}
  #   Locale:    ${i18n.defaultLocale}
  #   Time Zone: ${time.timeZone}
  # '' + (if services.xserver.enable then
  # ''
  #   Xserver:   Enabled
  # ''
  #   else
  # ''
  #   Xserver:   Disabled
  # '');

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
