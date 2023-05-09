{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    mpv = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [
        mpris
        thumbnail
      ];
    };
  };
}
