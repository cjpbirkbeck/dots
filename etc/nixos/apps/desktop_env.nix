# Configures my local, home settings

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};

  # These are absolute paths, which isn't ideal.
  # Some be replaced with path relative to ether this file or the main file.
  homeConfigFiles = /home/cjpbirkbeck/code/dots/home;
  xdgConfigFiles = /home/cjpbirkbeck/code/dots/home/config;

  largest32Int = 2147483647;

  commonAliases = {
    "nrb" = "sudo nixos-rebuild";
  };
in
{
  # Import home-manager
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.cjpbirkbeck = { pkgs, ... }: {
    home = {
      stateVersion = "19.09"; # DO NOT CHANGE!
      sessionVariables = {
        BROWSER = "firefox";
        LESSHISTFILE = "$HOME/.local/share/less/history";
        LESSKEY = "$HOME/.config/less/lesskey";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        TMUXP_CONFIGDIR = "$HOME/.config/tmuxp";
        UNICODE_CHARS = "$HOME/.local/share/unicode-chars";
        XCOMPOSECACHE = "$HOME/.cache/Xcompose/";

        # Setup for pfetch
        PF_INFO = "ascii os host kernel shell wm editor uptime";
        PF_COL1 = "9"; # Sets info names to white.
      };

      file = {
        tmuxp-default = {
          source = homeConfigFiles + /templates/tmuxp.yaml;
          target = "./Templates/tmuxp.yaml";
        };

        weatherrc = {
          source = homeConfigFiles + /weatherrc;
          target = ".weatherrc";
        };

        vimpc = {
          source = homeConfigFiles + /vimpcrc;
          target = ".vimpcrc";
        };

        XCompose = {
          source = homeConfigFiles + /XCompose;
          target = ".XCompose";
        };

        peekat = {
          source = homeConfigFiles + /local/bin/peekat;
          target = ".local/bin/peekat";
          executable = true;
        };

        unicode-chars = {
          source = homeConfigFiles + /local/share/unicode-chars;
          target = ".local/share/unicode-chars";
        };

        openup = {
          source = homeConfigFiles + /local/bin/openup;
          target = ".local/bin/openup";
          executable = true;
        };

        localbackup = {
          source = homeConfigFiles + /local/bin/localbackup;
          target = ".local/bin/localbackup";
          executable = true;
        };
      };
    };

    gtk = {
      enable = true;
      gtk2.extraConfig = ''
        gtk-theme-name="Breeze-Dark"
        gtk-icon-theme-name="breeze-dark"
        gtk-font-name="Sans 10"
        gtk-cursor-theme-name="breeze_cursors"
        gtk-cursor-theme-size=0
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
      gtk3 = {
        bookmarks = [
        ];
        extraConfig = {
          gtk-button-images = 0;
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
          theme = "desert";
          style = "full";
        };
        themes = {
          desert = builtins.readFile /home/cjpbirkbeck/code/dots/home/config/bat/themes/Desert.tmTheme;
        };
      };

      dircolors = {
        enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      fzf = {
        enable = true;
        changeDirWidgetOptions = [
          "--preview='ls -gAGh --color --group-directories-first {}'"
          "--ansi"
          "--no-multi"
          "--history=$HOME/.cache/fzf/change-directory-history"
        ];
        fileWidgetOptions = [
          "--preview='$HOME/.local/bin/peekat {}'"
          "--history=$HOME/.cache/fzf/file-widget-history"
        ];
      };

      gh = {
        enable = true;
      };

      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        ignores = [ ".envrc" "shell.nix" ".tmuxp.yaml" "extra.vim" ];
        userName = "Christopher Birkbeck";
        userEmail = "cjpbirkbeck@gmail.com";
        extraConfig = {
          pull = {
            rebase = false;
          };
        };
        delta = {
          enable = true;
        };
      };

      jq = {
        enable = true;
      };

      readline = {
        enable = true;
        extraConfig = ''
          
        '';
      };

      rofi = {
        enable = true;
        theme = "~/.config/rofi/themes/flat-ocean";
        extraConfig = {
          opacity = 80;
          modi = "window,run,combi,drun";
        };
      };

      password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR = "$HOME/.secrets/pass";
          PASSWORD_STORE_GENERATED_LENGTH = "31";
        };
      };

      pazi = {
        enable = true;
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
        terminal = "tmux-256color";
        tmuxp.enable = true;
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = logging;
            extraConfig = ''
              set -g @logging-path '$HOME/.local/share/tmux/logs'
            '';
          }
          {
            plugin = copycat;
          }
          {
            plugin = open;
          }
        ];
        extraConfig = ''
          # Enable true color and dynamic cusors shapes.
          set-option -sa terminal-overrides ',alacritty:RGB,st-256color:RGB'
          set-option -sa terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
          set-option -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'

          # Show title in terminal emulator title
          set-option -g set-titles on
          set-option -g set-titles-string "#S:#W:#T [#I/#{session_windows}:#P/#{window_panes}] - Tmux"

          # Use the system clipboard
          set -g set-clipboard on

          # Use emacs-style keybindings for the status-line
          set -g status-keys emacs

          # Split windows with more intuitive keybindings
          bind \\ split-window -h
          bind -  split-window -v

          bind C-- delete-buffer

          # Rebind switch client with C-i, which should be the same as Tab
          bind C-i switch-client -lZ

          # Cycle layouts
          bind ` next-layout

          # Reload source code
          bind r source $HOME/.config/tmux/tmux.conf

          # Enable the mouse
          set -g mouse on

          # Setup the status bar.
          set -g status-left '#[fg=#4D4D4D,bg=#98C379] ❰#{=/16/…:session_name}❱ #[default] '
          set -g status-left-length 20
          set -g window-status-current-format '#[reverse] {#I} #{=/16/…:window_name}#F #[noreverse]'
          set -g window-status-format '[#I] #{=/16/…:window_name}#F'
          set -g status-right ' #{?client_prefix, #[reverse](Prefix)#[noreverse],} #P/#{window_panes} #{=/16/…:pane_title}'
          set -g status-style 'fg=#87ceeb,bold,bg=#4d4d4d'
          set -g window-status-activity-style 'fg=#ee2b2a,bg=#4d4d4d,bold,reverse'
          set -g window-status-bell-style 'fg=#ee2b2a,bg=#4d4d4d,bold,reverse'
          set -g status-position top

          # Pane border style
          set -g pane-active-border-style 'fg=#ffffff,bg=#00FF7F'

          # Enable focus-events
          set -g focus-events on

          # Set history file for tmux
          set -g history-file $HOME/.cache/tmux/history
        '';
      };

      ssh = {
        enable = true;
        forwardAgent = true;
        hashKnownHosts = true;
        extraConfig = ''
          AddKeysToAgent yes
        '';
      };

      zsh = {
        enable = true;
        history = {
          extended = true;
          size = largest32Int;
          save = largest32Int;
          path = ".local/share/zsh/history";
        };
        initExtra = builtins.readFile /home/cjpbirkbeck/code/dots/home/local/share/zsh/functions.sh;
        shellAliases = commonAliases;
      };

      bash = {
        enable = true;
        historyFile = "\$HOME/.local/share/bash/history";
        historyFileSize = largest32Int;
        shellAliases = commonAliases;
      };

      zathura = {
        enable = true;
        options = {
          font = "monospace normal 12";
          incremental-search = true;
          window-title-basename = true;
          window-title-page = true;
          selection-clipboard = "clipboard";
          page-padding = 3;
        };
      };
    };

    services = {
      gnome-keyring = {
        enable = (if config.networking.hostName == "humboldt" then true else false);
      };

      mpd = {
        enable = true;
        musicDirectory = /home/cjpbirkbeck/audio;
        network.listenAddress = "127.0.0.1";
        network.port = 6600;
        extraConfig = ''
          auto_update "yes"

          restore_paused "yes"

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

      picom = {
        enable = true;
      };
    };

    # Use nix to manage the plugins globally, while configuring them per-user.
    xdg = {
      configFile = {
        "alacritty/alacritty.yml" = {
          source = xdgConfigFiles + "/alacritty/alacritty.yml";
        };

        "khard/config,conf" = {
          source = xdgConfigFiles + /khard/khard.conf;
        };

        "rofi-pass/config" = {
          source = xdgConfigFiles + /rofi-pass/config;
        };

        "neofetch/config.conf" = {
          source = xdgConfigFiles + /neofetch/config.conf;
        };

        "sxiv/exec/key-handler" = {
          source = xdgConfigFiles + /sxiv/exec/key-handler;
          executable = true;
        };

        "sxiv/exec/image-info" = {
          source = xdgConfigFiles + /sxiv/exec/image-info;
          executable = true;
        };

        "sxiv/exec/rename.sh" = {
          source = xdgConfigFiles + /sxiv/exec/rename.sh;
          executable = true;
        };

        "rofi/themes/flat-ocean.rasi" = {
          source = xdgConfigFiles + /rofi/themes/flat-ocean.rasi;
        };

        "tmuxp/general.yaml" = {
          source = xdgConfigFiles + /tmuxp/general.yaml;
        };
      };

      mimeApps = {
        enable = true;
        associations = {
          added = {
            "x-scheme-handler/mailto" = "userapp-Thunderbird-6DZAV0.desktop";
            "message/rfc822" = "userapp-Thunderbird-6DZAV0.desktop";
          };
        };
        defaultApplications = {
          "application/epub+zip" = [ "zathura.desktop" "org.pwmt.zathura.desktop" ];
          "application/pdf" = [ "zathura.desktop" "org.pwmt.zathura.desktop" ];
          "image/bmp" = [ "sxiv.desktop" "kolourpaint.desktop" ];
          "image/png" = [ "sxiv.desktop" "kolourpaint.desktop" ];
          "image/jpeg" = [ "sxiv.desktop" "kolourpaint.desktop" ];
          "x-scheme-handler/mailto" = [ "userapp-Thunderbird-6DZAV0.desktop" ];
          "message/rfc822" = [ "userapp-Thunderbird-6DZAV0.desktop" ];
        };
      };

      userDirs = {
        enable = true;
        desktop = "\$HOME/dt";
        download = "\$HOME/dls";
        templates = "\$HOME/tpls";
        music = "\$HOME/audio";
        pictures = "\$HOME/imgs";
        publicShare = "\$HOME/pub";
        videos = "\$HOME/vids";
        documents = "\$HOME/docs";
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

    xresources = {
      properties = {
        # Set properties for xterm, for when the occations when I need it.
        "XTerm.termName" = "xterm-256color";
        "XTerm.vt100.locale" = true;
        "XTerm.vt100.metaSendEscape" = true;
        "XTerm.vt100.saveLines" = 4096;
        "XTerm.vt100.faceName" = "sans mono:size=10:antialias=true";

        "XTerm.*.foreground" = "#c2c8d7";
        "XTerm.*.background" = "#1c262b";
        "XTerm.*.cursorColor" = "#b3b8c3";

        # Black
        "XTerm.*color0" = "#000000";
        "XTerm.*color8" = "#777777";

        # Red
        "XTerm.*color1" = "#ee2b2a";
        "XTerm.*color9" = "#dc5c60";

        # Green
        "XTerm.*color2" = "#40a33f";
        "XTerm.*color10" = "#70be71";

        # Yellow
        "XTerm.*color3" = "#ffea2e";
        "XTerm.*color11" = "#fff163";

        # Blue
        "XTerm.*color4" = "#1e80f0";
        "XTerm.*color12" = "#54a4f3";

        # Magenta
        "XTerm.*color5" = "#8800a0";
        "XTerm.*color13" = "#aa4dbc";

        # Cyan
        "XTerm.*color6" = "#16afca";
        "XTerm.*color14" = "#42c7da";

        # White
        "XTerm.*color7" = "#a4a4a4";
        "XTerm.*color15" = "#ffffff";

        # Bold, Italic, Underline
        "XTerm.*.colorBD" = "#ffffff";
      };
    };
  };
}
