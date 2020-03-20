# User settings

{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Montreal";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_CA.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cjpbirkbeck = {
    description = "Christopher Birkbeck";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "lp" ]; # Enable ‘sudo’ for the user.
  };

}
