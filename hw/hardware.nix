# Various hardware settings common across all currently used machines with NixOS.

{ pkgs, config, ... }:

{
  # Disks daemons
  services = {
    smartd = {
      enable = true;
      notifications.x11.enable = true;
    };

    fstrim = {
      enable = true;
    };
  };

  programs.gnome-disks.enable = true;

  # System information command line ultity
  environment.systemPackages = with pkgs; [ inxi smartmontools ];

  # Sounds
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
