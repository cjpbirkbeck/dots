# Configuration for using a Yuikey as FIDO 2fu token, OTP key and GPG smartcard.

{ pkgs, config, ... }:

{
  services = {
    udev.packages = with pkgs; [ yubikey-personalization ];

    # Smart card daemon
    pcscd.enable = true;
  };

  # environment.systemPackages = [ pkgs.yubioath-desktop ];
}
