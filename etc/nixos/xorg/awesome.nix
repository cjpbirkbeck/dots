# Setting for using AwesomeWM

{ config, pkgs, ... }:

{
  security = {
    pam = {
      services = {
        networkmanager = {
          enableGnomeKeyring = true;
        };
        lightdm.enableGnomeKeyring = true;
      };
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;

    xserver = {
      windowManager.awesome = {
        enable = true;

        luaModules = with pkgs; [
          luaPackages.vicious
        ];
      };

      desktopManager.xterm.enable = false;
    };
  };

  environment.systemPackages = with pkgs; [ xsecurelock ];

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
