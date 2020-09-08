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
    asciidoctor       # Convertor for asciidoc files
    atool             # Print archive file infomation
    bashdb            # Bash debugger.
    bats              # Automated tests with bash scripts.
    catdoc            # Converts Mircosoft Office to text
    catdocx           # Converts Mircosoft Office (post-2007) to text
    catimg            # A much better image to text converter
    checkbashisms     # Check for bash-specific syntax in POSIX scripts.
    dante             # SOCKS server; need for aerc
    ddgr              # Search DuckDuckGo from the command line
    detox             # Automatically make cli-friendly file names
    dict              # Command line dictionary
    exiftool          # Image file information
    ffmpegthumbnailer # Create video thumbnails
    ffmpeg            # Video encoder
    gcal              # Prints out almost any calendar and some holidays.
    graphicsmagick    # Command line graphic process
    isync             # POP/IMAP client
    jrnl              # Command line journal system.
    khard             # Address books
    libcaca           # Image to text converter
    mailcap           # Open non-plain-text emails
    maim              # Simple screenshot utility
    mediainfo         # Multimedia file information
    mpc_cli           # Barebones command line interface for mpd
    msmtp             # SMTP client
    neofetch          # An "About" screen for the terminal
    nix-index         # Locate for nix
    notmuch           # Email indexer
    odt2txt           # Converts odt (LibreOffice) to text
    pamixer           # Pulse Audio mixer
    pandoc            # Universal document converter
    pass              # Password manager
    pdd               # Date/time calculator
    playerctl         # Command-line MPRIS controller
    poppler_utils     # Converts pdf to text
    qrencode          # Prints out QR codes, when given a string of letters.
    sent              # Suckless's presentation software (default unpatched version)
    taskopen          # Open Taskwarrior annotations in various programs
    taskwarrior       # Tasks and TODOs
    translate-shell   # Search for translations (e.g. Google, Yandex) from the command line.
    trash-cli         # CLI program for working with Trash bin.
    units             # Convert between units
    unstable.ueberzug # Real images in the terminal!
    unzip             # List and extact zip file
    weather           # Weather command line
    xcape             # Binding a modifier key when press by itself.
    xclip             # Command line ultity for manuplating the system clipboard.
    xlsx2csv          # Converts Excel (post-2007) files to csv files
    youtube-dl        # Video downloader
    zip               # Compress zip files

    # TUI programs
    calc              # Calculator
    cava              # Visualiser for the terminal
    gotop             # Terminal base system monitor
    htop              # System resources monitor
    ncdu              # Filesystem size browser
    neomutt           # Ncurses email client
    newsboat          # RSS/Atom feed reader
    rlwrap            # Wrap readline library around certian prompts
    sc-im             # Terminal spreadsheet program
    tig               # Git frontend
    unstable.aerc     # Terminal email client
    unstable.calcurse # Calendar
    unstable.tuir     # Read reddit in a terminal
    vifm              # Terminal file manager
    vimpc             # TUI frontend for mpd
    vit               # Frontend for taskwarrior
    w3m               # Terminal web browser
    weechat           # IRC client

    # GUI applications
    alacritty            # Terminal emuator
    arc-theme            # Theme for GUI programs
    firefox              # GUI web browser
    flameshot            # Screenshot tool
    kp                   # Kolourpaint, a simple MS Paint clone
    mpv-with-scripts     # Customized mpv file
    networkmanagerapplet # Applet for connecting to wifi
    notify-desktop       # Desktop notify
    rofi-pass            # Frontend for quickly entering passwords with rofi.
    rofi                 # Program launcher/Window switcher/dmenu replacement
    screenkey            # Show keypress on the screen.
    st_patched           # Terminal emulator
    qutebrowser          # Another GUI browser
    sxiv                 # Lightweight image viewer
    thunderbird          # GUI email client
    # torbrowser           # Browser using the tor network
    zathura              # Lightweight PDF/EPUB/Dejv reader

    neovim_with_plugins    # Customized neovim.
    neovim-qt_with_plugins # GUI frontend using Qt.
    gnvim_with_plugins
    neovim-remote          # Control remote instances of neovim.

    miscfiles              # Misc files have a dictionary list that is useful for vim autocompletions.
    universal-ctags        # Tags files that will hold keyword information.

    breeze-gtk
    breeze-icons
    breeze-qt5
    gnome-breeze
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

    zoom-us
  ];
in
{
  imports = [
    <home-manager/nixos>
    ./overrides/nvim.nix
    ./overrides/mpv.nix
    ./overrides/st.nix
  ];

  # Packages that should be accessible to all user, including root.
  environment.systemPackages = with pkgs; [
    dash                 # POSIX Shell
    file                 # Determine the type of a file.
    tree                 # Show contents of directories in a tree format.
    gitAndTools.gitFull  # Defacto standard version control
    lsof                 # Lists open files
    shellcheck           # Linter for shell scripts.
    udiskie              # Frontend of udisks.
    rsync                # Simple archival program
    rclone               # rsync for cloud storage
    borgbackup           # Deduplication backup tool
    inxi                 # Comand line system information
        # Battery information
  ] ++ (if config.networking.hostName == "humboldt" then [ acpi ] else []);

  users.users.cjpbirkbeck.packages = core ++
    (if config.services.xserver.enable then general else []) ++
    (if config.networking.hostName == "archimedes" then full else []);

  environment.variables = {
    LESSHISTFILE = "$HOME/.local/share/less/history";
    LESSKEY = "$HOME/.config/less/lesskey";

    BAT_STYLE = "full";
  };
}
