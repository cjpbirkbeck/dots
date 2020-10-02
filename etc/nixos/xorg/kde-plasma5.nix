# Setting for KDE Plasma 5

{ pkgs, config, ... }:

{
  services.xserver = {
    enable = true;

    desktopManager.plasma5.enable = true;
    desktopManager.xterm.enable = false;
  };
}
