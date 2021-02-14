# System-wide configuration for all (POSIX-compatible) shells.

{ config, pkgs, ... }:

{
  programs.command-not-found.enable = true;

  services.lorri.enable = true;

  environment = {
    shells = with pkgs; [ bashInteractive zsh ];

    variables = {
      LESSHISTFILE = "$HOME/.local/share/less/history";
      LESSKEY = "$HOME/.config/less/lesskey";

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

      # Quickly pop directory list.
      p = "popd";

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
      ncdu  = "ncdu --color dark";

      # Program aliases
      more  = "less";
      dff   = "df -hH -x tmpfs -x devtmpfs";
      fr    = "free --human";

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
    };

    ssh = {
      startAgent = true;
    };
  };
}
