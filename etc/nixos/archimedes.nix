# Various settings that applies only for archimedes, my desktop.

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
    ./system/fonts.nix
    ./system/locale.nix
    ./system/upgrades.nix
    ./system/cjpbirkbeck.nix
    ./system/elma.nix

    # Shell configuration
    ./shells/shells.nix
    ./shells/bash.nix
    ./shells/zsh.nix
    ./shells/tmux.nix
    ./shells/ssh.nix

    # Xorg Server configuration
    ./xorg/lightdm.nix
    ./xorg/kde-plasma5.nix
    ./xorg/awesome.nix

    # Application specific settings
    ./apps/desktop_env.nix
    ./apps/applications.nix
    ./apps/gaming.nix
    ./apps/overrides/scripts.nix
    ./apps/scripts/rofi-as-dmenu.nix
    ./apps/dev-env/golang.nix
  ];

  boot.loader = {
    timeout = 10;

    systemd-boot = {
      enable = true;
      consoleMode = "auto";
      configurationLimit = 50;
    };
  };

  time.hardwareClockInLocalTime = true;

  networking = {
    hostName = "archimedes";

    nameservers = [ "192.168.1.11" ];

    useDHCP = false;

    interfaces.eno1.useDHCP = true;
  };

  services = {
    locate = {
      enable = true;
      interval = "8,16:00";
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    logind = {
      extraConfig = ''
        HandleSuspendKey=ignore
      '';
    };
  };

  virtualisation = {
    anbox.enable = true;

    virtualbox.host = {
      enable = true;
    };
  };

  system.stateVersion = "18.03";
}
