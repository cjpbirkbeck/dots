# Font configuration

{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      # corefonts
      weather-icons
      powerline-fonts
      noto-fonts
      hack-font
      font-awesome
      emacs-all-the-icons-fonts
      noto-fonts-emoji
      inconsolata
      fira-mono
      ubuntu_font_family
    ];

    fontconfig.defaultFonts = {
      monospace = [ "Hack" "Noto Mono"];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };
}
