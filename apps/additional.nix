{ config, pkgs, ...}:

{
  programs.java.enable = true;

  users.users.cjpbirkbeck.packages = with pkgs; [
    gimp      # Complex raster editor
    inkscape  # Vector editor

    asunder   # CD Ripper
    handbrake # DVD Ripper
    brasero   # CD Burner
    audacity  # Waveform editor

    brave     # Web browser
  ];
}
