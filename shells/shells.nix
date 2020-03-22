# System-wide configuration for all (POSIX-compatible) shells.

{ config, pkgs, ... }:

{
  programs.command-not-found.enable = true;

  services.lorri.enable = true;

  environment = {
    shells = with pkgs; [ bashInteractive zsh ];

   systemPackages = with pkgs; [
      dash       # POSIX Shell
      file       # Determine the type of a file.
      tree       # Show contents of directories in a tree format.
      fasd       # Jump to commonly used directories.
      fzf        # Fuzzy finder user interface.
      git        # Defacto standard version control
      bat        # cat(1) clone with syntax highlighting.
      fd         # find clone
      ripgrep    # grep clone
      lsof       # Lists open files
      zip        # Create ZIP files
      unzip      # Extact files from ZIP files.
      wget       # Command line file downloader
      curl       # Command line file downloader
      shellcheck # Linter for shell scripts.
      stow       # Symlink manager
    ];

    variables = {
      BAT_STYLE = "full";
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

      l  = "ls -l";     # List directories with a long format.
      ll = "ls -lA";    # List all directories with a long format
      lx = "ls -lXB";   # List files by file extension
      lz = "ls -lSr";   # List files by size
      la = "ls -A";     # list hidden files

      # Appearance

      # Colourize commands.
      tree  = "tree -C";
      grep  = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";

      ## Program aliases
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
  };
}
