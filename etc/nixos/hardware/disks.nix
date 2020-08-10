# Setting for working with various disks.

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

  # Add disk monitoring tools
  environment.systemPackages = with pkgs; [ smartmontools ];
}
