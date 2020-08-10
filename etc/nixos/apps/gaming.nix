# Configuring a system for using Steam or playing games from GOG.com.
# All work and no fun makes Jack a dull boy.

{ pkgs, config, ... }:

let
  gnomePackages = with pkgs.gnome3; [
    gnome-mines   # Minesweeper
    quadrapassel  # Tetris
    gnome-chess   # Chess
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  hardware = {
    opengl = {
      enable = true;

      driSupport32Bit = true;
    };

    pulseaudio.support32Bit = true;
  };

  users.users.cjpbirkbeck.packages = with pkgs; [
    gnuchess  # Chess engine
    rftg      # Race for the Galaxy

    steam
    steam-run
  ] ++ gnomePackages;
}
