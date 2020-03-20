{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      gnupg

      pass
      rofi-pass
    ];

    variables = {
      GNUGHOME = "$HOME/.secrets/gnupg";

      PASSWORD_STORE_DIR = "$HOME/.secrets/pass";
      PASSWORD_STORE_GENERATED_LENGTH = "31";
    };
  };
}
