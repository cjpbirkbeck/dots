# Configuring a system for using Steam or playing games from GOG.com.
# All work and no fun makes Jack a dull boy.

{ pkgs, config, ... }:

{
  nixpkgs.config.allowUnfree = true;

  users.users.cjpbirkbeck.packages = with pkgs; [
    vivaldi
  ];
}
