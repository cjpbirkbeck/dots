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

    # Shell configuration
    ./shells/shells.nix
    ./shells/bash.nix
    ./shells/z_shell.nix
    ./shells/tmux.nix
    ./shells/ssh.nix

    # Xorg Server configuration
    ./xorg/lightdm.nix
    ./xorg/awesome.nix

    # Application specific settings
    ./apps/desktop_env.nix
    ./apps/applications.nix
    ./apps/bitlbee.nix
    ./apps/gaming.nix
    ./apps/overrides/scripts.nix
    ./apps/devlopement/golang.nix
  ];

  programs.evolution = {
    enable = true;
  };

  programs.dconf = {
    enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };

    tlp = {
      enable = true;
    };

    xserver.xautolock = {
      enable = false;

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

  # Doesn't seem to activate on its own.
  boot.kernelParams = [ "intel_pstate=active" ];

  system.stateVersion = "19.09";
}
