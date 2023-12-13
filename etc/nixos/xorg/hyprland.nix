{ pkgs, config, ... }:

let

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

  programs.sway.enable = true;
  programs.hyprland.enable = true;
  programs.river.enable = true;
  services.xserver.windowManager.qtile = {
    enable = true;
    backend = "wayland";
    # extraPackages = with pkgs.python3Packages; [
    #   qtile-extras
    # ];
  };

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.greetd = {
    enable = true;
    vt = 6;
    package = pkgs.greetd.tuigreet;
    settings = {
      default_session.command = with config; ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --time-format "%c" \
          --greeting "${text_greeting}" \
          --asterisks \
          --user-menu \
          --cmd river
        '';
      };
  };

  environment.etc."greetd/environments".text = ''
    river
    hikari
    qtile start -b wayland
    Hyprland
    sway
  '';

  sound.enable = true;
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

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.polkit-kde-agent
    # dbus-sway-environment
    glib
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    hikari
    breeze-icons
    fortune
  ];
}
