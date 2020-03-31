# Miscellanous programs to install.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    vifm        # Terminal file manager

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

    spacefm     # Graphical file manager

    # Documents
    zathura     # Lightweight PDF/EPUB/Dejv reader
    pandoc      # Document converter
    libreoffice # Office suite

    # Images
    sxiv                        # Lightweight image viewer
    kdeApplications.kolourpaint # MS Paint clone

    # Multimedia
    mpd                 # Music player daemon
    mpc_cli             # Barebones command line interface for mpd
    vimpc               # TUI frontend for mpd
    mpd-mpris           # Interfaces mpris with mpd
    mpv-with-scripts    # Lightweight music player
    playerctl           # Command-line MPRIS controller
    ffmpeg              # Video encoder
    ffmpegthumbnailer   # Create video thumbnails

    # Web browsers
    firefox
    brave
    w3m

    # Email
    thunderbird   # Also does calendaring, task, RSS feeds and Chat
    unstable.aerc # Terminal based email client
    dante         # SOCKS Client, need for aerc
    khard         # Command line address book

    # Calendars and task.
    calcurse
    taskopen
    vit

    # RSS Feed Reader
    newsboat

    # Video downloader
    youtube-dl

    # Backup tools
    rsync
    rclone
    borgbackup

    # Miscellaneous
    neofetch        # An "About" screen for the terminal
    ddgr            # Search DuckDuckGo from the command line
    pdd             # Date/time calculator
    gcal            # Prints out almost any calendar and some holidays.
    translate-shell # Search for translations (e.g. Google, Yandex) from the command line.
    htop            # TUI system resources monitor
    ncdu            # TUI filesystem size browser
    qrencode        # Prints out QR codes, when given a string of letters.
  ];

  environment.shellAliases = {
    ncdu = "ncdu --color dark";
    calcurse = "calcurse --confdir $HOME/.config/calcurse --datadir $HOME/.local/share/calcurse";
  };

  environment.variables = {
    BROWSER = "firefox";
  };
}
