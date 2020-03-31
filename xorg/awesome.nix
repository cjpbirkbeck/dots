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
    systemPackages = with pkgs; [
      termite              # Terminal emuator
      xorg.xmodmap         # For rebinding keys
      xcape                # Binding a modifier key when press by itself.
      trash-cli            # CLI program for working with Trash bin.

      rofi                 # Program launcher/Window switcher/dmenu replacement
      conky                # GUI System Monitor
      lxappearance-gtk3    # Theme programs using gtk3

      arc-theme            # Theme for GUI programs
      acpi                 # Required for battery information
      networkmanagerapplet # Applet for connecting to wifi
      udiskie              # Frontend of udisks.

      pass                 # Password manager
      rofi-pass            # Frontend for quickly entering passwords with rofi.

      xclip                # Command line ultity for manuplating the system clipboard.

      screenkey            # Show keypress on the screen.
      notify-desktop       # Desktop notify
      maim                 # Simple screenshot utility
      xsecurelock          # Simple screenlocker

      weather              # Weather command line

      breeze-gtk
      breeze-icons
      breeze-plymouth
      breeze-qt5
      gnome-breeze
    ];

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
