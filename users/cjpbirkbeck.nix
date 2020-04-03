# Configures my local, home settings

{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  imports = [
    <home-manager/nixos>
  ];

  # Define my basic user details.
  users.users.cjpbirkbeck = {
    description = "Christopher Birkbeck";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "lp" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.cjpbirkbeck = { pkgs, ... }: {

    home = {
      stateVersion = "19.09";
      sessionVariables = {
        XCOMPOSEFILE = "$HOME/.config/X11/XCompose";
        XCOMPOSECACHE = "$HOME/.config/X11/XCompose";
        GTK_IM_MODULE = "xim";
        QT_IM_MODULE = "xim";
      };
    };

    manual = {
      manpages.enable = true;
    };

    programs = {
      bat = {
        enable = true;
        config = {
          theme = "ansi-dark";
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

      mpv = {
        enable = true;
        config = {
          input-ipc-server = "/tmp/mpv";
          slang = "en";
        };
      };

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
        };

        # These files *should* point to the root directory,
        # assuming that xdg.configFile symlinks to ~/.config
        "X11/XCompose" = {
          source = ./home-manager/XCompose;
        };

        "../.weatherrc" = {
          source = ./home-manager/weatherrc;
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
