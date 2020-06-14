# Installs programming environments for various LISPs.

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Scheme
    chez
    chicken
  ];
}
