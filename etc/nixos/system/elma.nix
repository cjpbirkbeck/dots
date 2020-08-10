{ config, pkgs, ... }:

{
    users.users.elma = {
      isNormalUser = true;
      home = "/home/elma";
      description = "Elma Bulatao";
      extraGroups = [ "lp" "scanner" "networkmanager" ];

      packages = with pkgs; [
        firefox
        skanlite
        brave
        zoom-us
      ];
    };
}
