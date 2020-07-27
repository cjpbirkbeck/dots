# Configures my local, home settings

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  # Import home-manager
  imports = [
    <home-manager/nixos>
  ];

  environment.shellAliases = {
    ncdu = "ncdu --color dark";
    # calcurse = "calcurse --confdir $HOME/.config/calcurse --datadir $HOME/.local/share/calcurse";
  };

  programs.gnome-disks.enable = true;

  home-manager.users.cjpbirkbeck = { pkgs, ... }: {
    home = {
      stateVersion = "19.09";
      sessionVariables = {
        BROWSER = "firefox";
        XCOMPOSEFILE = "$HOME/.config/X11/XCompose";
        XCOMPOSECACHE = "$HOME/.config/X11/XCompose";
        GTK_IM_MODULE = "xim";
        QT_IM_MODULE = "xim";
        TMUXP_CONFIGDIR = "$HOME/.config/tmuxp";
        UNICODE_CHARS = "$HOME/.local/share/unicode-chars";
        # GNUPGHOME = "$HOME/.secrets/gnupg";
      };

      file = {
        tmuxp-default = {
          source = ./home-manager/tmuxp.yaml;
          target = "Templates/.tmuxp.yaml";
        };

        weatherrc = {
          source = ./home-manager/weatherrc;
          target = ".weatherc";
        };

        vimpc = {
          source = ./home-manager/vimpcrc;
          target = ".vimpcrc";
        };

        peekat = {
          source = ./home-manager/bin/peekat;
          target = ".local/bin/peekat";
          executable = true;
        };

        unicode-chars = {
          source = ./home-manager/unicode-chars;
          target = ".local/share/unicode-chars";
        };

        openup = {
          source = ./home-manager/bin/openup;
          target = ".local/bin/openup";
          executable = true;
        };

        localbackup = {
          source = ./home-manager/bin/localbackup;
          target = ".local/bin/localbackup";
          executable = true;
        };

        takepicof = {
          source = ./home-manager/bin/takepicof;
          target = ".local/bin/takepicof";
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
          "file:///home/cjpbirkbeck/Audio"
          "file:///home/cjpbirkbeck/Images"
        ];
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

      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
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
        # ignores = [ ".envrc" "shell.nix" ".tmuxp.yaml" ];
        userName = "Christopher Birkbeck";
        userEmail = "cjpbirkbeck@gmail.com";
      };

      # gpg = {
      #   enable = true;
      # };

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
        theme = "~/.config/rofi/themes/flat-ocean";
        extraConfig = ''
          ! Opacity
          rofi.opacity: 80

          ! Enable modes
          rofi.modi: window,run,combi,drun
        '';
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
        enableBashIntegration = true;
        enableZshIntegration = true;
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
            plugin = yank;
          }
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

          # Show title in terminal emulator title
          set-option -g set-titles on
          set-option -g set-titles-string "#S:#W:#T [#I/#{session_windows}:#P/#{window_panes}] - Tmux"

          # Use emacs-style keybindings for the status-line
          set -g status-keys emacs

          # Split windows with more intuitive keybindings
          bind | split-window -h
          bind - split-window -v

          bind C-- delete-buffer

          # Cycle layouts with C-i, which should be the same as Tab
          bind C-i next-layout

          # Reload source code
          bind r source $HOME/.tmux.conf

          # Enable the mouse
          set -g mouse on

          # Set the default status bar style.
          set -g status-left '#[reverse] #{=/16/…:session_name} #[noreverse]'
          set -g status-left-length 20
          set -g window-status-current-format '#[reverse] #I  #{=/16/…:window_name}#F #[noreverse]'
          set -g window-status-format ' #I  #{=/16/…:window_name}#F'
          set -g status-right ' #{?client_prefix,#[reverse] Prefix #[noreverse] ,}#P/#{window_panes} #{=/16/…:pane_title}'
          set -g status-style 'fg=#87ceeb,bold,bg=#4d4d4d'
          set -g window-status-activity-style 'fg=#ee2b2a,bold,bg=#4d4d4d'
          set -g window-status-bell-style 'fg=#ee2b2a,bold,bg=#4d4d4d'
          set -g status-position top

          # Pane border style
          set -g pane-active-border-style 'fg=#ffffff,bg=#00FF7F'
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
      gnome-keyring = {
        enable = (if config.networking.hostName == "humboldt" then true else false);
      };

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

      picom = {
        enable = true;
        # extraOptions = ''
        #   "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
        # '';
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

        "rofi/themes/Material-Ocean.rasi" = {
          source = ./home-manager/rofi/Material-Ocean.rasi;
        };

        "rofi/themes/flat-orange.rasi" = {
          source = ./home-manager/rofi/flat-orange.rasi;
        };

        "rofi/themes/flat-ocean.rasi" = {
          source = ./home-manager/rofi/flat-ocean.rasi;
        };

        "tmuxp/general.yaml" = {
          source = ./home-manager/tmuxp/general.yaml;
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
