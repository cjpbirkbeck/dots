# Locale settings

{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Montreal";

  i18n.defaultLocale = "en_CA.UTF-8";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
