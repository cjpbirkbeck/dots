# Installs "minimal" programs, often but not always TUI programs.
# The name is a lie, but I cannot think of better word.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  # Import various overriden packages.
  imports = [
    ./overrides/nvim.nix
    ./overrides/mpv.nix
    ./overrides/st.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      alacritty            # Terminal emuator
      # xorg.xmodmap         # For rebinding keys
      xcape                # Binding a modifier key when press by itself.
      trash-cli            # CLI program for working with Trash bin.

      rofi                 # Program launcher/Window switcher/dmenu replacement
      conky                # GUI System Monitor
      lxappearance-gtk3    # Theme programs using gtk3

      arc-theme            # Theme for GUI programs
      acpi                 # Required for battery information
      networkmanagerapplet # Applet for connecting to wifi
      udiskie              # Frontend of udisks.

      pass                 # Password manager
      rofi-pass            # Frontend for quickly entering passwords with rofi.

      xclip                # Command line ultity for manuplating the system clipboard.

      screenkey            # Show keypress on the screen.
      notify-desktop       # Desktop notify
      maim                 # Simple screenshot utility

      weather              # Weather command line

      vifm                 # Terminal file manager
      libcaca              # Image to text converter
      catimg               # A much better image to text converter
      highlight            # Highlights syntax in a file
      atool                # Print archive file infomation
      poppler_utils        # Converts pdf to text
      exiftool             # Image file information
      mediainfo            # Multimedia file information
      odt2txt              # Converts odt (LibreOffice) to text
      catdoc               # Converts Mircosoft Office to text
      catdocx              # Converts Mircosoft Office (post-2007) to text
      xlsx2csv             # Converts Excel (post-2007) files to csv files

      sxiv                 # Lightweight image viewer
      zathura              # Lightweight PDF/EPUB/Dejv reader

      mpc_cli              # Barebones command line interface for mpd
      vimpc                # TUI frontend for mpd
      # mpd-mpris            # Interfaces mpris with mpd
      playerctl            # Command-line MPRIS controller

      w3m                  # Terminal web browser
      unstable.aerc        # Email client
      dante                # SOCKS server; need for aerc
      khard                # Address books
      calcurse             # Calendar
      taskwarrior          # Tasks and TODOs
      jrnl                 # Command line journal system.
      taskopen             # Open Taskwarrior annotations in various programs
      vit                  # Frontend for taskwarrior
      newsboat             # RSS/Atom feed reader
      tig                  # Git frontend
      htop                 # System resources monitor
      ncdu                 # Filesystem size browser
    ];

    shellAliases = {
      ncdu = "ncdu --color dark";
      calcurse = "calcurse --confdir $HOME/.config/calcurse --datadir $HOME/.local/share/calcurse";
    };

  };
}
