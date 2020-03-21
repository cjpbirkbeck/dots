# Settings that are specific for "humboldt", my laptop.

{ pkgs, config, ... }:

{
  imports = [
    # Hardware-specific settings
    ./hw/hardware.nix
    ./hw/printer.nix
    ./hw/yubikey.nix

    # System-wide settings
    ./sys/boot.nix
    ./sys/fonts.nix
    ./sys/users.nix
    ./sys/upgrades.nix
    ./sys/backup.nix

    # User-specific configurations
    ./users/cjpbirkbeck.nix

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
    ./apps/applications.nix
    ./apps/security.nix
    ./apps/custom/emacs.nix
    ./apps/custom/nvim.nix
    ./apps/custom/scripts.nix
    ./apps/dev/lisp.nix
    ./apps/dev/golang.nix
    ./apps/dev/rust.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    trackpoint = {
      enable = true;
    };
  };

  services = {
    tlp = {
      enable = true;
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
