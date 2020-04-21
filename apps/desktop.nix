# Configures my local, home settings

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  kp = pkgs.kdeApplications.kolourpaint;
in
{
  # Import my overrides.
  imports = [
    <home-manager/nixos>
    ./overrides/nvim.nix
    ./overrides/mpv.nix
    ./overrides/st.nix
  ];

  environment.shellAliases = {
    ncdu = "ncdu --color dark";
    calcurse = "calcurse --confdir $HOME/.config/calcurse --datadir $HOME/.local/share/calcurse";
  };

  programs.gnome-disks.enable = true;

  users.users.cjpbirkbeck.packages = with pkgs; [
    # Command line tools
    atool             # Print archive file infomation
    catdoc            # Converts Mircosoft Office to text
    catdocx           # Converts Mircosoft Office (post-2007) to text
    catimg            # A much better image to text converter
    dante             # SOCKS server; need for aerc
    ddgr              # Search DuckDuckGo from the command line
    exiftool          # Image file information
    ffmpeg            # Video encoder
    ffmpegthumbnailer # Create video thumbnails
    gcal              # Prints out almost any calendar and some holidays.
    highlight         # Highlights syntax in a file
    jrnl              # Command line journal system.
    khard             # Address books
    libcaca           # Image to text converter
    maim              # Simple screenshot utility
    mediainfo         # Multimedia file information
    mpc_cli           # Barebones command line interface for mpd
    neofetch          # An "About" screen for the terminal
    odt2txt           # Converts odt (LibreOffice) to text
    pass              # Password manager
    pdd               # Date/time calculator
    playerctl         # Command-line MPRIS controller
    poppler_utils     # Converts pdf to text
    qrencode          # Prints out QR codes, when given a string of letters.
    taskopen          # Open Taskwarrior annotations in various programs
    taskwarrior       # Tasks and TODOs
    translate-shell   # Search for translations (e.g. Google, Yandex) from the command line.
    trash-cli         # CLI program for working with Trash bin.
    unstable.ueberzug # Real images in the terminal!
    weather           # Weather command line
    xcape             # Binding a modifier key when press by itself.
    xclip             # Command line ultity for manuplating the system clipboard.
    xlsx2csv          # Converts Excel (post-2007) files to csv files

    # TUI programs
    calcurse          # Calendar
    cava              # Visualiser for the terminal
    htop              # System resources monitor
    ncdu              # Filesystem size browser
    newsboat          # RSS/Atom feed reader
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
    lxappearance-gtk3 # Theme programs using gtk3
    notify-desktop    # Desktop notify
    rofi              # Program launcher/Window switcher/dmenu replacement
    rofi-pass         # Frontend for quickly entering passwords with rofi.
    screenkey         # Show keypress on the screen.
    sxiv              # Lightweight image viewer
    thunderbird       # GUI email client
    torbrowser        # Browser using the tor network
    zathura           # Lightweight PDF/EPUB/Dejv reader
  ];

  home-manager.users.cjpbirkbeck = { pkgs, ... }: {
    home = {
      stateVersion = "19.09";
      sessionVariables = {
        BROWSER = "firefox";
        XCOMPOSEFILE = "$HOME/.config/X11/XCompose";
        XCOMPOSECACHE = "$HOME/.config/X11/XCompose";
        GTK_IM_MODULE = "xim";
        QT_IM_MODULE = "xim";
        GNUPGHOME = "$HOME/.secrets/gnupg";
        PASSWORD_STORE_DIR = "$HOME/.secrets/pass";
        PASSWORD_STORE_GENERATED_LENGTH = "31";
      };

      file = {
        weatherrc = {
          source = ./home-manager/weatherrc;
          target = ".weatherc";
        };

        vimpc = {
          source = ./home-manager/vimpcrc;
          target = ".vimpcrc";
        };
      };
    };

    gtk = {
      enable = true;
      gtk3 = {
        extraConfig = {
          gtk-button-images = 0;
          # gtk-cursor-theme-name = "breeze_cursors";
          gtk-cursor-theme-size = 0;
          gtk-enable-event-sounds = 1;
          gtk-enable-input-feedback-sounds = 1;
          gtk-font-name = "Sans 10";
          gtk-icon-theme-name = "breeze-dark";
          gtk-menu-images = 0;
          gtk-theme-name = "Breeze-Dark";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
        };
        extraCss = ''
        VteTerminal, vte-terminal {
          padding: 1px;
        }
        '';
      };
    };

    manual = {
      manpages.enable = true;
    };

    programs = {
      bat = {
        enable = true;
        config = {
          theme = "zenburn";
          style = "full";
        };
      };

      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        changeDirWidgetOptions = [ "--preview='ls -gAGh --color --group-directories-first {}'" "--ansi" "--no-multi" ];
        fileWidgetOptions = [ "--preview='$HOME/.local/bin/peekat {} $FZF_PREVIEW_COLUMNS'" ];
      };

      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "Christopher Birkbeck";
        userEmail = "cjpbirkbeck@gmail.com";
      };

      # mpv = {
      #   enable = true;
      #   config = {
      #     input-ipc-server = "/tmp/mpv";
      #     slang = "en";
      #   };
      # };

      jq = {
        enable = true;
      };

      rofi = {
        enable = true;
        theme = "paper-float";
        extraConfig = ''

          ! Opacity
          rofi.opacity: 80

          ! Enable modes
          rofi.modi: window,run,combi,drun
        '';
      };

      taskwarrior = {
        enable = true;
      };

      tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 10;
        keyMode = "vi";
        customPaneNavigationAndResize = true;
        shortcut = "Space";
        sensibleOnTop = false;
        terminal = "screen-256color";
        extraConfig = ''
          # Use emacs-style keybindings for the status-line
          set -g status-keys emacs

          # Split windows with more intuitive keybindings
          bind | split-window -h
          bind - split-window -v

          bind C-- delete-buffer

          # Enable the mouse
          set -g mouse on

          # Set the default status bar style.
          set -g status-left '#[reverse]#S #[noreverse]'
          # set -g window-status-separator ''
          # set -g window-status-current-style 'reverse'
          set -g window-status-current-format '#[reverse] #I  #W* #[noreverse]'
          set -g window-status-format ' #I  #W#{?window_last_flag,-,}'
          set -g status-right ' #{?client_prefix,#[reverse] Prefix #[noreverse] ,}#P/#{window_panes} #{=24:pane_title} #[reverse] #h'
          set -g status-style 'fg=#87ceeb,bold,bg=#4e4e4e'
          set -g status-position top

          # Pane border style
          set -g pane-active-border-style 'fg=#ffffff,bg=#00FF7F'
        '';
      };

      termite = {
        enable = false;
        backgroundColor = "rgba(29,40,55,1.0)";
        colorsExtra = ''
          cursor = #bbbbbb
          foreground = #ffffff
          color0 = #000000
          color1 = #f9555f
          color2 = #21b089
          color3 = #fef02a
          color4 = #589df6
          color5 = #944d95
          color6 = #1f9ee7
          color7 = #bbbbbb
          color8 = #555555
          color9 = #fa8c8f
          color10 = #35bb9a
          color11 = #ffff55
          color12 = #589df6
          color13 = #e75699
          color14 = #3979bc
          color15 = #ffffff
          colorBD = #ffffff
          colorIT =
          colorUL =
        '';
        iconName = "utilities-terminal";
        searchWrap = true;
        scrollbar = "off";
        filterUnmatchedUrls = true;
        allowBold = true;
        browser = "firefox";
        clickableUrl = true;
        cursorBlink = "system";
        cursorShape = "block";
        dynamicTitle = true;
        font = "Deja Vu Sans Mono 11";
        modifyOtherKeys = false;
        scrollbackLines = -1;
        sizeHints = false;
        hintsFont = "Inconsolata 12";
        hintsForegroundColor = "#dcdccc";
        hintsBackgroundColor = "#3f3f3f";
      };

      zsh = {
        enable = true;
        dotDir = ".config/zsh";
        history = {
          path = ".local/share/zsh/history";
        };
        initExtra = builtins.readFile ./home-manager/zsh/functions.sh;
        shellAliases = {
          "_" = "sudo";
          "__" = "sudo -i";

          "nrb" = "sudo nixos-rebuild";
        };
      };

      bash = {
        enable = true;
        historyFile = ".local/share/bash/history";
      };

      zathura = {
        enable = true;
        options = {
          font = "monospace normal 12";
          incremental-search = true;
          window-title-page = true;
          selection-clipboard = "clipboard";
          page-padding = 3;
        };
      };
    };

    services = {
      mpd = {
        enable = true;
        musicDirectory = /home/cjpbirkbeck/Audio;
        extraConfig = ''
          auto_update "yes"

          restore_paused "yes"
          max_output_buffer_size "16384"

          audio_output {
                type  "pulse"
                name  "pulse audio"
                mixer_type "software"
          }

          audio_output {
            type               "fifo"
            name               "toggle_visualizer"
            path               "/tmp/mpd.fifo"
            format             "44100:16:2"
          }
        '';
      };

      mpdris2 = {
        enable = true;
        multimediaKeys = true;
        notifications = true;
      };
    };

    # Use nix to manage the plugins globally, while configuring them per-user.
    xdg = {
      configFile = {
        "alacritty/alacritty.yml" = {
          source = ./home-manager/alacritty/alacritty.yml;
        };

        "khard/config,conf" = {
          source = ./home-manager/khard/khard.conf;
        };

        "rofi-pass/config" = {
          source = ./home-manager/rofi-pass/config;
        };

        "vifm" = {
          source = ./home-manager/vifm;
          recursive = true;
        };

        "neofetch/config.conf" = {
          source = ./home-manager/neofetch/config.conf;
        };

        "sxiv/exec/key-handler" = {
          source = ./home-manager/sxiv/exec/key-handler;
          executable = true;
        };

        "sxiv/exec/image-info" = {
          source = ./home-manager/sxiv/exec/image-info;
          executable = true;
        };

        "sxiv/exec/rename.sh" = {
          source = ./home-manager/sxiv/exec/rename.sh;
          executable = true;
        };

        # These files *should* point to the root directory,
        # assuming that xdg.configFile symlinks to ~/.config
        "X11/XCompose" = {
          source = ./home-manager/XCompose;
        };

        # Right now, vimpc does not seem be able to read the XDG
        # config file. Not sure why; keeping both versions until that is fixed.
        "./vimpc/.vimpcrc" = {
          source = ./home-manager/vimpcrc;
        };
      };

      userDirs = {
        enable = true;
        music = "\$HOME/Audio";
        pictures = "\$Home/Images";
      };
    };

    xsession = {
      enable = true;

      windowManager.awesome = {
        enable = true;

        luaModules = with pkgs.luaPackages; [
          vicious
        ];
      };
    };
  };
}
