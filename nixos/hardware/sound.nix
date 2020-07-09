# Settings for enabling sound.

{ pkgs, config, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
