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
    ./system/auto-upgrade.nix
    ./system/cjpbirkbeck.nix
    ./system/blockedhosts.nix

    # Shell configuration
    ./shells/shells.nix
    ./shells/bash.nix
    ./shells/zsh.nix
    ./shells/tmux.nix
    ./shells/ssh.nix

    # Xorg Server configuration
    ./xorg/lightdm.nix
    ./xorg/awesome.nix

    # Application specific settings
    ./apps/desktop_env.nix
    ./apps/applications.nix
    ./apps/gaming.nix
    ./apps/overrides/scripts.nix
    ./apps/devlopement/golang.nix
  ];

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };

    tlp = {
      enable = true;
    };

    xserver.xautolock = {
      enable = true;

      locker = "${pkgs.xsecurelock}/bin/xsecurelock";
    };

    tor.enable = true;
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
