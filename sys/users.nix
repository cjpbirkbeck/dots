# Locale settings

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
}
