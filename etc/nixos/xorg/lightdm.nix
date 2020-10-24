# Configuration for LightDM

{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;

      greeters = {
        gtk.clock-format = "%A, %B %d %Y [%U] %I:%M:%S %p %Z";
      };

      extraConfig = ''
        [Seat:*]
        greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
      '';
    };
  };

  environment.systemPackages = [ pkgs.numlockx ];
}
