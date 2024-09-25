{ pkgs, lib, ... }:

{
    services.xserver.enable = true;
    services.xserver.displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        theme = "${pkgs.sddm-chili-theme}/share/themes/chili/Main.qml";
    };
    services.xserver.windowManager.cwm.enable = true;
}
