{ config, pkgs, ... }: let unstable = import <unstable> {};

  # kp = pkgs.kdeGear.kolourpaint;

  # Core packages that should be accessible on all machines.
  core = with pkgs; [
    fd      # find replacement
    ripgrep # grep replacement
    curl    # Transfer files from a URL
  ];

  # Programs that should be on any machine with X server on it.
  general = with pkgs; [
    # Command line tools
    afew                      # Notmuch tagger
    asciinema                 # Record terminal sessions
    atool                     # Compressed file mangement
    boxes                     # Create text boxes
    catdoc                    # Converts Mircosoft Office to text
    catdocx                   # Converts Mircosoft Office (post-2007) to text
    catimg                    # A much better image to text converter
    dante                     # SOCKS server; need for aerc
    ddgr                      # Search DuckDuckGo from the command line
    detox                     # Automatically make cli-friendly file names
    exiftool                  # Image file information
    ffmpeg                    # Video encoder
    ffmpegthumbnailer         # Create video thumbnails
    gcal                      # Prints out almost any calendar and some holiday
    googler                   # Search Google from command line
    graphicsmagick            # Command line graphic process
    gron                      # JSON command line processor
    hunspell                  # Spell checker
    hunspellDicts.en_CA-large # Canadian English dictionary
    hunspellDicts.fr-moderne  # French language dictionary
    isync                     # POP/IMAP client
    jrnl                      # Command line journal system.
    khard                     # Address books
    libcaca                   # Image to text converter
    libqalculate              # Advanced calculator for the command line
    mailcap                   # Open non-plain-text emails
    mediainfo                 # Multimedia file information
    miscfiles                 # Misc files have a dictionary list that is useful for vim autocompletions.
    mpc_cli                   # Barebones command line interface for mpd
    msmtp                     # SMTP client
    neofetch                  # An "About" screen for the terminal
    nix-index                 # Locate for nix
    unstable.notmuch          # Email indexer
    odt2txt                   # Converts odt (LibreOffice) to text
    pamixer                   # Pulse Audio mixer
    pandoc                    # Universal document converter
    pass                      # Password manager
    pdd                       # Date/time calculator
    pfetch                    # Minimalist text fetch program
    playerctl                 # Command-line MPRIS controller
    poppler_utils             # Converts pdf to text
    qrencode                  # Prints out QR codes, when given a string of letters.
    remind                    # Command-line calendar
    shellcheck                # Linter for shell scripts.
    taskopen                  # Open Taskwarrior annotations in various programs
    taskwarrior               # Tasks and TODOs
    translate-shell           # Search for translations (e.g. Google, Yandex) from the command line.
    trash-cli                 # CLI program for working with Trash bin.
    tree-sitter
    tree_sitter_with_packages
    units                     # Convert between units
    universal-ctags           # Tags files that will hold keyword information.
    weather                   # Weather command line
    wyrd                      # TUI frontend for remind
    xcape                     # Binding a modifier key when press by itself.
    xclip                     # Command line ultity for manuplating the system clipboard.
    xdotool                   # Automation tool for X11
    xlsx2csv                  # Converts Excel (post-2007) files to csv files
    youtube-dl                # Video downloader
    lowdown

    # TUI programs
    abook                     # Terminal address book.
    alot                      # TUI for notmuch email.
    bombadillo                # Alternate protocol browser
    bvi                       # vi-like hex editor
    cava                      # Visualiser for the terminal
    clac                      # Fancy RPN calculator
    glow                      # Terminal markdown reader
    gnvim_with_plugins        # Another GUI frontend using Qt, but with Rust.
    gotop                     # Terminal base system monitor
    htop                      # System resources monitor
    ledger                    # Financial management with plain text
    lnav                      # vi-like log viewer
    meli                      # TUI email client
    ncdu                      # Filesystem size browser
    neomutt                   # Ncurses email client
    neovim-qt_with_plugins    # GUI frontend using Qt.
    neovim-remote             # Control remote instances of neovim.
    newsboat                  # RSS/Atom feed reader
    rlwrap                    # Wrap readline library around certian prompts
    sc-im                     # Terminal spreadsheet program
    tig                       # Git frontend
    unstable.aerc             # Terminal email client
    unstable.calcurse         # Calendar
    unstable.tuir             # Read reddit in a terminal
    vifm-full                 # Terminal file manager
    latest_vimpc                     # TUI frontend for mpd
    visidata                  # Tabular data viewer
    vit                       # Frontend for taskwarrior
    w3m                       # Terminal web browser
    unstable.weechat          # IRC client
    ytfzf                     # Console search for Youtube
    gomuks     # Matrix client
    toot       # Mastadon client
    turses     # Twitter client

    # GUI applications
    astroid                   # GUI client for notmuch
    anki                      # Flashcard application
    arc-theme                 # Theme for GUI programs
    firefox                   # GUI web browser
    unstable.flameshot                 # Screenshot tool
    gromit-mpx                # On-screen annotator
    kolourpaint               # Kolourpaint, a simple MS Paint clone
    imv                       # Lightweight image viewer
    mpv-with-scripts          # Customized mpv file
    nheko                     # Matrix client
    networkmanagerapplet      # Applet for connecting to wifi
    notify-desktop            # Desktop notify
    rofi-pass                 # Frontend for quickly entering passwords with rofi.
    rofi                      # Program launcher/Window switcher/dmenu replacement
    pcmanfm-qt                # GUI file manager
    qtox                      # Tox client
    qt5ct                     # Configure Qt5 outside of KDE Plasma
    qalculate-gtk             # Graphical calculator
    screenkey                 # Show keypress on the screen.
    st_patched                # Terminal emulator
    qutebrowser               # Another GUI browser
    sxiv                      # Lightweight image viewer
    thunderbird               # GUI email client
    unstable.torbrowser       # Browser using the tor network
    zathura                   # Lightweight PDF/EPUB/Dejv reader

    # Icons for theming GTK and Qt applications with the breeze theme.
    breeze-gtk
    breeze-icons
    breeze-qt5
    gnome-breeze

    # Keep these here for now
    gimp                      # Complex raster editor
    inkscape                  # Vector editor
    libreoffice               # Office suite

    # UGH
    zoom-us

    appimage-run
  ];

  # Packages that only need to be on my desktop
  full = with pkgs; [
    ark         # GUI archive manager
    gwenview    # KDE image viewer
    okular      # KDE document viewer

    gimp        # Complex raster editor
    inkscape    # Vector editor
    libreoffice # Office suite

    asunder     # CD Ripper
    handbrake   # DVD Ripper
    brasero     # CD Burner

    zoom-us     # Proprietary videoconferencing client
  ];
in
{
  imports = [
    <home-manager/nixos>
    ./overrides/nvim.nix
    ./overrides/mpv.nix
    ./overrides/st.nix
    ./overrides/vimpc.nix
  ];

  # Packages that should be accessible to all user, including root.
  environment.systemPackages = with pkgs; [
    dash                 # POSIX Shell
    gparted              # Graphical paritioning tool
    file                 # Determine the type of a file.
    tree                 # Show contents of directories in a tree format.
    gitAndTools.gitFull  # Defacto standard version control.
    git-crypt            # Encypt files in git repositories.
    lsof                 # Lists open files
    udiskie              # Frontend of udisks.
    rsync                # Simple archival program
    rclone               # rsync for cloud storage
    borgbackup           # Deduplication backup tool
    inxi                 # Command line system information
    usbutils             # Info about usb ports
        # Battery information
  ] ++ (if config.networking.hostName == "humboldt" then [ acpi ] else []);

  users.users.cjpbirkbeck.packages = core ++
    (if config.services.xserver.enable then general else []) ++
    (if config.networking.hostName == "archimedes" then full else []);
}
