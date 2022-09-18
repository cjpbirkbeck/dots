# { config, pkgs, ... }: let unstable = import <unstable> {};
#   version = "11.5.3";
# in unstable.tor-browser-bundle-bin.overrideAttrs(old: {
#   src = pkgs.fetchurl {
#     url = "....";
#     sha256 = "...";
#   };
#   inherit version;
#   name = "tor-browser-bundle-bin-${version}";
# })

{ pkgs, config, ... }:

let
  version = "11.5.2";
  lang = "en-US";
in
{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
    temp_tor = tor-browser-bundle-bin.overrideAttrs ( oldAttr: rec {
      src = pkgs.fetchurl {
        url = "https://tor.calyxinstitute.org/dist/torbrowser/${version}/tor-browser-linux64-${version}_${lang}.tar.xz";
        sha256 = "sha256-kM3OOFTpEU7nIyqqdGcqLZ86QLb6isM5cfWG7jo891o=";
      };
      inherit version;
      name = "tor-browser-bundle-bin-${version}";
    } );
  };
}
