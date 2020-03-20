{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    stow
    gist
  ];
}
