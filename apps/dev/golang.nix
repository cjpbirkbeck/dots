# Setting for working with Go language programming.

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
  ];
}
