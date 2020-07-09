# Setting for KDE Plasma 5

{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    ark
    gwenview
    okular
  ];

  services.xserver = {
    enable = true;

    desktopManager.plasma5.enable = true;
    desktopManager.xterm.enable = false;
  };
}
