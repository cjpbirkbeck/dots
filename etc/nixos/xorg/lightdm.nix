# Configuration for LightDM Display Manager

{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;

      greeters = {
        gtk = {
          clock-format = "%A, %B %d %Y [%U] %I:%M:%S %p %Z";

          cursorTheme = {
            package = pkgs.breeze-icons;

            name = "breeze-dark";
          };
        };
      };

      # Set Numlock on by default.
      extraConfig = ''
        [Seat:*]
        greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
      '';
    };
  };

  environment.systemPackages = [ pkgs.numlockx pkgs.breeze-icons ];
}
