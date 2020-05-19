# Font configuration

{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      # corefonts
      weather-icons
      font-awesome
      emacs-all-the-icons-fonts
      noto-fonts-emoji
      inconsolata
      ubuntu_font_family
    ];
  };
}
