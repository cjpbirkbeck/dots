# Configuring a system for using Steam or playing games from GOG.com.
# All work and no fun makes Jack a dull boy.

{ pkgs, config, ... }:

{
  nixpkgs.config.allowUnfree = true;

  hardware = {
    opengl = {
      enable = true;

      driSupport32Bit = true;
    };

    pulseaudio.support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    steam
    steam-run
  ];
}
