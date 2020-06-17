{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  kp = pkgs.kdeApplications.kolourpaint;

  # Core packages that should be accessible 
  core = with pkgs; [
    fd      # find replacement
    ripgrep # grep replacement
    zip     # Create zip files
    unzip   # Uncompress zip files
    curl    # Transfer files from a URL
    wget    # Transfer files from a URL
  ];

  # Programs that should be on any machine with X server on it.
  general = with pkgs; [
    # Command line tools
    atool             # Print archive file infomation
    asciidoctor       # Convertor for asciidoc files
    catdoc            # Converts Mircosoft Office to text
    catdocx           # Converts Mircosoft Office (post-2007) to text
    catimg            # A much better image to text converter
    dante             # SOCKS server; need for aerc
    detox             # Automatically make cli-friendly file names
    ddgr              # Search DuckDuckGo from the command line
    exiftool          # Image file information
    ffmpeg            # Video encoder
    ffmpegthumbnailer # Create video thumbnails
    gcal              # Prints out almost any calendar and some holidays.
    graphicsmagick    # Command line graphic process
    highlight         # Highlights syntax in a file
    jrnl              # Command line journal system.
    khard             # Address books
    libcaca           # Image to text converter
    maim              # Simple screenshot utility
    mediainfo         # Multimedia file information
    mpc_cli           # Barebones command line interface for mpd
    neofetch          # An "About" screen for the terminal
    nix-index         # Locate for nix
    odt2txt           # Converts odt (LibreOffice) to text
    pass              # Password manager
    pamixer           # Pulse Audio mixer
    pandoc
    pdd               # Date/time calculator
    playerctl         # Command-line MPRIS controller
    poppler_utils     # Converts pdf to text
    qrencode          # Prints out QR codes, when given a string of letters.
    taskopen          # Open Taskwarrior annotations in various programs
    taskwarrior       # Tasks and TODOs
    translate-shell   # Search for translations (e.g. Google, Yandex) from the command line.
    trash-cli         # CLI program for working with Trash bin.
    unstable.ueberzug # Real images in the terminal!
    unzip             # List and extact zip file
    weather           # Weather command line
    xcape             # Binding a modifier key when press by itself.
    xclip             # Command line ultity for manuplating the system clipboard.
    xlsx2csv          # Converts Excel (post-2007) files to csv files
    zip               # Compress zip files

    # TUI programs
    calcurse          # Calendar
    cava              # Visualiser for the terminal
    htop              # System resources monitor
    ncdu              # Filesystem size browser
    newsboat          # RSS/Atom feed reader
    gotop             # Terminal base system monitor
    sc-im             # Terminal spreadsheet program
    tig               # Git frontend
    unstable.aerc     # Terminal email client
    unstable.tuir     # Read reddit in a terminal
    vifm              # Terminal file manager
    vimpc             # TUI frontend for mpd
    vit               # Frontend for taskwarrior
    w3m               # Terminal web browser

    # GUI applications
    alacritty         # Terminal emuator
    arc-theme         # Theme for GUI programs
    conky             # GUI System Monitor
    firefox           # GUI web browser
    kp                # Kolourpaint, a simple MS Paint clone
    notify-desktop    # Desktop notify
    rofi              # Program launcher/Window switcher/dmenu replacement
    rofi-pass         # Frontend for quickly entering passwords with rofi.
    screenkey         # Show keypress on the screen.
    sxiv              # Lightweight image viewer
    thunderbird       # GUI email client
    torbrowser        # Browser using the tor network
    zathura           # Lightweight PDF/EPUB/Dejv reader
  ];

  # Packages that only need to be on my desktop
  full = with pkgs; [
    gimp      # Complex raster editor
    inkscape  # Vector editor

    asunder   # CD Ripper
    handbrake # DVD Ripper
    brasero   # CD Burner
    audacity  # Waveform editor

    brave     # Web browser
  ];
in
{
  # Packages that should be accessible to all user, including root.
  environment.systemPackages = with pkgs; [
    dash                 # POSIX Shell
    file                 # Determine the type of a file.
    tree                 # Show contents of directories in a tree format.
    gitAndTools.gitFull  # Defacto standard version control
    lsof                 # Lists open files
    shellcheck           # Linter for shell scripts.
    acpi                 # Required for battery information
    networkmanagerapplet # Applet for connecting to wifi
    udiskie              # Frontend of udisks.
    rsync                # Simple archival program
    rclone               # rsync for cloud storage
    borgbackup           # Deduplication backup tool
  ];

  users.users.cjpbirkbeck.packages = core ++
    (if config.services.xserver.enable then general else []) ++
    (if config.networking.hostName == "archimedes" then full else []);

  environment.variables = {
    LESSHISTFILE = "$HOME/.local/share/less/history";
    LESSKEY = "$HOME/.config/less/lesskey";

    BAT_STYLE = "full";
  };
}
