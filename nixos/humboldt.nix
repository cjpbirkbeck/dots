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
    ./hardware/io.nix

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
    ./shells/ssh.nix

    # Xorg Server configuration
    ./xorg/lightdm.nix
    # ./xorg/kde-plasma5.nix
    ./xorg/awesome.nix

    # Application specific settings
    ./apps/desktop.nix
    ./apps/applications.nix
    ./apps/overrides/scripts.nix
    ./apps/scripts/rofi-as-dmenu.nix
    ./apps/dev-env/lisp.nix
    ./apps/dev-env/golang.nix
    ./apps/syncthing.nix
    # ./apps/dev-env/rust.nix
  ];

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
