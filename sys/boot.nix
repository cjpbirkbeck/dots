# Configure common boot sequence settings, using UEFI and GNU GRUB instead of the awful systemd-boot.

{ pkgs, config, ... }:

{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };

    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
    };
  };
}
