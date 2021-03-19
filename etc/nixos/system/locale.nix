# Locale settings

{ config, pkgs, ... }:

{
  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = (if config.services.xserver.enable then true else false);
    # Use the Oceanic Material colours
    colors = [
      "000000"
      "ee2b2a"
      "40a33f"
      "ffea2e"
      "1e80f0"
      "8800a0"
      "16afca"
      "a4a4a4"
      "777777"
      "dc5c60"
      "70be71"
      "fff163"
      "54a4f3"
      "aa4dbc"
      "42c7da"
      "ffffff"
    ];
  };
}
