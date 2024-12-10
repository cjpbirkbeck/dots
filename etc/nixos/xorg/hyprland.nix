{ pkgs, config, ... }:

let

unstable = import <unstable> {};

text_greeting = with config; ''
Welcome!

OS: NixOS ${system.nixos.release} (${system.nixos.codeName})
Version: ${system.nixos.version}
Kernel: Linux ${boot.kernelPackages.kernel.version}
Locale: ${i18n.defaultLocale}
Login shells: bash ${pkgs.bashInteractive.version}, zsh ${pkgs.zsh.version}

Your riddle/platitude/piece of wisdom of the day:
$(${pkgs.fortune.out}/bin/fortune wisdom riddles platitudes -s)
'';

in
{
  programs.labwc.enable = true;
  programs.sway.enable = true;
  programs.hyprland.enable = true;
  programs.river.enable = true;
  programs.waybar.enable = true;
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      # qtile-extras
      pyxdg
    ];
  };

  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
  security.pam.services.waylock = {};

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-kde
    ];
  };

  # services.greetd = {
  #   enable = true;
  #   vt = 6;
  #   package = pkgs.greetd.tuigreet;
  #   settings = {
  #     default_session.command = with config; ''
  #       ${pkgs.greetd.tuigreet}/bin/tuigreet \
  #         --time \
  #         --time-format "%c" \
  #         --greeting "${text_greeting}" \
  #         --asterisks \
  #         --user-menu \
  #         --cmd river
  #       '';
  #     };
  # };

  environment.systemPackages = with pkgs; [
    libsForQt5.polkit-kde-agent
    glib
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    # hikari
    labwc
    unstable.swww
    unstable.swayimg
    breeze-icons
    fortune
    unstable.wl-clipboard
    unstable.foot
    unstable.fastfetch
    unstable.fuzzel
    unstable.waybar
    unstable.wlr-randr
    usbimager
    unstable.waylock
  ];
}
