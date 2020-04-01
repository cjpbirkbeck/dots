# Setting for using AwesomeWM

{ config, pkgs, ... }:

{
  security = {
    pam = {
      services = {
        networkmanager = {
          enableGnomeKeyring = true;
        };
      };
    };
  };

  services = {
    compton = {
      # enable = true;

      # backend = "glx";
    };

    gnome3.gnome-keyring.enable = true;

    xserver = {
      windowManager.awesome = {
        enable = true;

        luaModules = with pkgs; [
          luaPackages.vicious
        ];
      };

      desktopManager.xterm.enable = false;

      xautolock = {
        enable = true;

        locker = "${pkgs.xsecurelock}/bin/xsecurelock";
      };
    };
  };

  environment = {
    etc = {
      "weatherrc" = {
        enable = true;
        text = ''
          [cyul]
          cache=True
          cache_data=True
          cache_search=True
          cachedir=~/.cache/weather
          cacheage=900
        '';
      };
    };
  };
}
