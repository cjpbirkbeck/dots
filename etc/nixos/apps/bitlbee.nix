{ config, pkgs, ... }:

let
  
in
{
  services = {
    bitlbee = {
      enable = true;
      plugins = [
        pkgs.bitlbee-facebook
      ];
      libpurple_plugins = [
        pkgs.purple-matrix
      ];
    };
  };

}
