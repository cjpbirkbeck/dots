{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      gnupg

      pass
      rofi-pass
    ];

    variables = {
      GNUPGHOME = "$HOME/.secrets/gnupg";

      PASSWORD_STORE_DIR = "$HOME/.secrets/pass";
      PASSWORD_STORE_GENERATED_LENGTH = "31";
    };
  };
}
