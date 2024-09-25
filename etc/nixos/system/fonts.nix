# Font configuration

{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
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
      jetbrains-mono
      iosevka
      source-code-pro
      hack-font
      ibm-plex
      tamzen
      fira-mono
      terminus_font
    ];

    fontconfig.defaultFonts = {
      monospace = [ "Hack" "Noto Mono"];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };
}
