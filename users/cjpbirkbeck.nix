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
        # TEST_VAR = "Hello world";
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
        dataLocation = "~/.local/share/task";
      };

      termite = {
        enable = true;
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
        initExtra = builtins.readFile ./dotfiles/functions.sh;
        shellAliases = {
          "_" = "sudo";
          "__" = "sudo -i";
        };
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
        musicDirectory = /home/cjpbirkbeck/Music;
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

    home.packages = [ pkgs.bash ];
    programs.bash.enable = true;
    programs.bash.shellAliases = {
      "..." = "cd ../..";
    };

    # Use nix to manage the plugins globally, while configuring them per-user.
    xdg.configFile."nvim/init.vim" = {
      source = ./dotfiles/common.vim;
    };

    xdg.configFile = {
      "vifm" = {
        source = ./dotfiles/vifm;
        recursive = true;
      };

      "neofetch/config.conf" = {
        source = ./dotfiles/neofetch/config.conf;
      };

      "sxiv/exec/key-handler" = {
        source = ./dotfiles/sxiv/exec/key-handler;
        executable = true;
      };

      "sxiv/exec/image-info" = {
        source = ./dotfiles/sxiv/exec/image-info;
      };
    };
  };

}
