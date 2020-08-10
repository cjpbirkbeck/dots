{ config, pkgs, ... }:

let
  rofi-as-dmenu = pkgs.writeScriptBin "dmenu" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.rofi}/bin/rofi -dmenu "$@"
  '';
in
{
  environment.systemPackages = [ rofi-as-dmenu ];
}
