# Sets up programs for desktop use.

{ config, pkgs, ... }:

{
  # I prefer using a GUI utility over working with disk destroyer.
  # Enables the program to work with manually sudo it in shell.
  programs.gnome-disks.enable = true;

  environment = {
    systemPackages = with pkgs; [
      spaceFM                     # Graphical file browser
      firefox                     # Web browser
      brave                       # Another web browser
      thunderbird                 # Email client
      libreoffice                 # Office suite
      kdeApplications.kolourpaint # MS Paint clone
    ];

    variables = {
      BROWSER = "firefox";
    };
  };
}
