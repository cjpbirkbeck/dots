{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    mpv-with-scripts = pkgs.mpv-with-scripts.override {
      scripts = with pkgs.mpvScripts; [
        mpris
        thumbnail
      ];
    };
  };
}
