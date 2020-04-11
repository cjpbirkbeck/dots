{ config, pkgs, ... }:

{
  # Define my basic user details.
  users.users.cjpbirkbeck = {
    description = "Christopher Birkbeck";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "lp" ];
  };
}
