# Settings that are specific for "humboldt", my laptop.

{ pkgs, config, ... }:

{
  imports = [
    # Import the auto generated hardware settings
    /etc/nixos/hardware-configuration.nix

    # Hardware-specific settings
    ./hardware/disks.nix
    ./hardware/sound.nix
    ./hardware/printer.nix
    ./hardware/yubikey.nix

    # System-wide settings
    ./system/boot.nix
    ./system/fonts.nix
    ./system/locale.nix
    ./system/upgrades.nix
    ./system/backup.nix
    ./system/cjpbirkbeck.nix

    # Shell configuration
    ./shells/shells.nix
    ./shells/bash.nix
    ./shells/zsh.nix
    ./shells/tmux.nix

    # Xorg Server configuration
    ./xorg/lightdm.nix
    ./xorg/kde-plasma5.nix
    ./xorg/awesome.nix

    # Application specific settings
    ./apps/desktop.nix
    # ./apps/minimal.nix
    ./apps/applications.nix
    ./apps/overrides/scripts.nix
    ./apps/scripts/rofi-as-dmenu.nix
    # ./apps/dev/lisp.nix
    ./apps/dev/golang.nix
    # ./apps/dev/rust.nix
  ];

  hardware = {
    trackpoint = {
      enable = true;
    };
  };

  # Customize the T430 keyboard
  home-manager.users.cjpbirkbeck = { pkgs, ... }: {
    home.keyboard = {
      layout = "us";
      options = [ "compose:menu" "ctrl:nocaps" "altwin:prtsc_rwin" "shift:both_capslock" ];
    };

    services.xcape = {
      enable = true;
      mapExpression = {
        Control_L = "Escape";
        Super_R = "Print";
        Super_L = "#135"; # Menu key
      };
    };
  };

  services = {
    tlp = {
      enable = true;
    };

    xserver.xautolock = {
      enable = true;

      locker = "${pkgs.xsecurelock}/bin/xsecurelock";
    };
  };

  networking = {
    hostName = "humboldt";

    useDHCP = false;

    interfaces = {
      wlp3s0 = {
        useDHCP = true;
      };

      enp0s25 = {
        useDHCP = true;
      };
    };

    networkmanager = {
      enable = true;
    };
  };

  system.stateVersion = "19.09";
}
