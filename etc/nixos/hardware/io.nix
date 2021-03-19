# Configure the keyboard and mouse for my user,
# remaping different keys for different machines.

{ config, pkgs, ... }:

let
  name = config.networking.hostName;
in
{
  home-manager.users.cjpbirkbeck = { pkgs, ... }: {
    home.keyboard = {
      layout = "us";
      options = [  "compose:menu" "ctrl:nocaps" "shift:both_capslock" ] ++
        (if name == "humboldt" then [ "altwin:prtsc_rwin" ] else []);
    };

    services.xcape = {
      enable = true;
      mapExpression = {
        Control_L = "Escape";
        Super_L = "#135"; # Menu key
      } // (if name == "humboldt" then { Super_R = "Print"; } else {});
    };
  };

  hardware = {
    trackpoint = {
      enable = (if name == "humboldt" then true else false);
    };
  };

  services.xserver.libinput = {
    enable = true;
  };
}
