# Configuration for my printer, an HP All-in-One.
# Note that I am configuring the printer manually, with the web interface.

{ pkgs, config, ... }:

{
  nixpkgs.config.allowUnfree = true;

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 9100 ];

  services = {
    printing = {
      enable = true;

      drivers = [ pkgs.hplipWithPlugin ];
    };
  };
}
