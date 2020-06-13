# Font configuration

{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      # corefonts
      weather-icons
      powerline-fonts
      font-awesome
      emacs-all-the-icons-fonts
      noto-fonts-emoji
      inconsolata
      fira-mono
      ubuntu_font_family
    ];
  };
}
