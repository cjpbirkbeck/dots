# Configuring a system for using Steam or playing games from GOG.com.
# All work and no fun makes Jack a dull boy.

{ pkgs, config, ... }:

let
  gnomePackages = with pkgs.gnome3; [
    quadrapassel  # Tetris
    gnome-chess   # Chess
    aisleriot
  ];
in
{
  # nixpkgs.config.allowUnfree = true;

  # hardware = {
  #   opengl = {
  #     enable = true;

  #     driSupport32Bit = true;
  #   };

  #   pulseaudio.support32Bit = true;
  # };

  users.users.cjpbirkbeck.packages = with pkgs; [
    gnuchess  # Chess engine
    gnugo     # Go engine
    freeciv
    freesweep
    kblocks
    kmines
    kigo
    rftg      # Race for the Galaxy

    # steam
    # steam-run
  ] ++ gnomePackages;
}
