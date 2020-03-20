{ config, pkgs, ... }:

{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };

    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
    };
  };

  hardware = {
    u2f.enable = true;

    trackpoint = {
      enable = true;
    };

    sane = {
      enable = true;
    };
  };

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];

    pcscd.enable = true;
    
    nfs = {
      server.enable = true;
    };
    
    tlp = {
      enable = true;
    };

    avahi = {
      enable = true;
    };

    acpid = {
      enable = true;
    };

    printing = {
      enable = true;
    };

    smartd = {
      enable = true;
    };

    fstrim = {
      enable = true;
    };
  };

  networking = {
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

  programs = {
    gnome-disks.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      inxi
      acpi
    ];
  };
}
