# Configures my local, home settings

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  kp = pkgs.kdeApplications.kolourpaint;
in
{
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
    alacritty            # Terminal emuator
    # xorg.xmodmap         # For rebinding keys
    xcape                # Binding a modifier key when press by itself.
    trash-cli            # CLI program for working with Trash bin.

    rofi                 # Program launcher/Window switcher/dmenu replacement
    conky                # GUI System Monitor
    lxappearance-gtk3    # Theme programs using gtk3

    arc-theme            # Theme for GUI programs

    pass                 # Password manager
    rofi-pass            # Frontend for quickly entering passwords with rofi.

    xclip                # Command line ultity for manuplating the system clipboard.

    screenkey            # Show keypress on the screen.
    notify-desktop       # Desktop notify
    maim                 # Simple screenshot utility

    weather              # Weather command line

    vifm                 # Terminal file manager
    firefox
    thunderbird
    kp
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

    ffmpeg            # Video encoder
    ffmpegthumbnailer # Create video thumbnails

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

    neofetch          # An "About" screen for the terminal
    ddgr              # Search DuckDuckGo from the command line
    pdd               # Date/time calculator
    gcal              # Prints out almost any calendar and some holidays.
    translate-shell   # Search for translations (e.g. Google, Yandex) from the command line.
    qrencode          # Prints out QR codes, when given a string of letters.
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

      termite = {
        enable = true;
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

        "../.weatherrc" = {
          source = ./home-manager/weatherrc;
        };

        # Right now, vimpc does not seem be able to read the XDG
        # config file. Not sure why; keeping both versions until that is fixed.
        "./vimpc/.vimpcrc" = {
          source = ./home-manager/vimpcrc;
        };

        "../.vimpcrc" = {
          source = ./home-manager/vimpcrc;
        };

      };

      userDirs = {
        enable = true;
        music = "\$HOME/Audio";
        pictures = "\$Home/Images";
      };
    };
  };
}
