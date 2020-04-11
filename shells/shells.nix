# System-wide configuration for all (POSIX-compatible) shells.

{ config, pkgs, ... }:

{
  programs.command-not-found.enable = true;

  services.lorri.enable = true;

  environment = {
    shells = with pkgs; [ bashInteractive zsh ];

   systemPackages = with pkgs; [
      dash                # POSIX Shell
      file                # Determine the type of a file.
      tree                # Show contents of directories in a tree format.
      fasd                # Jump to commonly used directories.
      fzf                 # Fuzzy finder user interface.
      gitAndTools.gitFull # Defacto standard version control
      bat                 # cat(1) clone with syntax highlighting.
      fd                  # find clone
      ripgrep             # grep clone
      lsof                # Lists open files
      zip                 # Create ZIP files
      unzip               # Extact files from ZIP files.
      wget                # Command line file downloader
      curl                # Command line file downloader
      shellcheck          # Linter for shell scripts.
      stow                # Symlink manager
    ];

    variables = {
      LESSHISTFILE = "$HOME/.local/share/less/history";
      LESSKEY = "$HOME/.config/less/lesskey";

      BAT_STYLE = "full";

      _FASD_DATA = "$HOME/.local/share/fasd/history";
      _FASD_SHELL = "dash";
    };

    shellAliases = {
      # File system aliases

      # Enable intractive mode by default.
      rm = "rm -I --preserve-root";
      cp = "cp -i";
      mv = "mv -i";
      ln = "ln -i";

      # Preserve root from ch* commands.
      chown = "chown --preserve-root";
      chmod = "chmod --preserve-root";
      chgrp = "chgrp --preserve-root";

      # Alias for making symlinks.
      sl = "ln -s";

      # ls Aliases
      # ls should have readable sizes, be coloured and list directories first.
      ls = "ls --human-readable --color=auto --group-directories-first";

      l  = "ls -l";   # List directories with a long format.
      ll = "ls -lA";  # List all directories with a long format
      lt = "ls -lt";  # List files by time (newest first)
      lT = "ls -ltr"; # List files by time (oldest first)
      lx = "ls -lXB"; # List files by file extension
      lz = "ls -lSr"; # List files by size
      la = "ls -A";   # list hidden files

      # Appearance

      # Colourize commands.
      less  = "less -R";
      tree  = "tree -C --dirsfirst";
      grep  = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";

      # Program aliases
      more  = "less";

      # Aliases for nix programs.
      nrb   = "nixos-rebuild";
      nev   = "nix-env";
      ncg   = "nix-collect-garbage";
      nsh   = "nix-shell";
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
    };

    ssh = {
      startAgent = true;
    };
  };
}
