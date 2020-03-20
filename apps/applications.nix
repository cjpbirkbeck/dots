# Miscellanous programs to install.

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  programs.java.enable = true;

  environment.systemPackages = with pkgs; [

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
    playerctl           # 
    ffmpeg              # Video encoder
    ffmpegthumbnailer

    # Web browsers
    firefox
    brave
    w3m

    # Email
    thunderbird   # Also does calendaring, task, RSS feeds and Chat
    unstable.aerc # Terminal based email client
    dante         # SOCKS Client, need for aerc
    khard         # Command line address book

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

  environment.variables = {
    BROWSER = "firefox";
  };
}
