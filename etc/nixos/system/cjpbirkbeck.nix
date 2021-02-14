{ config, pkgs, ... }:

{
  users.motd = with config; ''
    Welcome to ${networking.hostName}!

    - This server is managed by NixOS
    - All changes are futile

    OS:      NixOS ${system.nixos.release} (${system.nixos.codeName})
    Version: ${system.nixos.version}
    Kernel:  ${boot.kernelPackages.kernel.version}
  '';

  # Define my basic user details.
  users.users.cjpbirkbeck = {
    description = "Christopher Birkbeck";
    isNormalUser = true;
    extraGroups = [ "doas" "wheel" "networkmanager" "lp" "scanner" "networkmanager" "vboxusers" ];
  };
}
