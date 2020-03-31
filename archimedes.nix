# Various settings that applies only for archimedes, my desktop.

{ pkgs, config, ... }:

{
  boot = {
    timeout = 10;

    grub.useOSProber = true;
  };

  time.hardwareClockInLocalTime = true;

  networking = {
    hostName = "archimedes";

    nameservers = [ "192.168.1.11" ];
  };

  virutalisation = {
    virtualbox.host = {
      enable = true;
    };
  };

  system.stateVersion = "18.03";
}
