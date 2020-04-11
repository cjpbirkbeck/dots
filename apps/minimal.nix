# Hold various programs used mostly on the command line.

{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      file              # Determine the type of a file.
      tree              # Show contents of directories in a tree format.
      fasd              # Jump to commonly used directories.
      fzf               # Fuzzy finder user interface.
      git               # Defacto standard version control
      bat               # cat(1) clone with syntax highlighting.
      fd                # find clone
      ripgrep           # grep clone
      lsof              # Lists open files
      zip               # Create ZIP files
      unzip             # Extact files from ZIP files.
      wget              # Command line file downloader
      curl              # Command line file downloader
      shellcheck        # Linter for shell scripts.
      bashdb            # Bash debugger.
      bats              # Automated tests with bash scripts.
      checkbashisms     # Check for bash-specific syntax in POSIX scripts.
      youtube-dl        # Video downloader
      pandoc            # Text converter
      gnupg

      acpi                 # Required for battery information
      networkmanagerapplet # Applet for connecting to wifi
      udiskie              # Frontend of udisks.
      rsync             # Simple archival program
      rclone            # rsync for cloud storage
      borgbackup        # Deduplication backup tool
    ];

    variables = {
      LESSHISTFILE = "$HOME/.local/share/less/history";
      LESSKEY = "$HOME/.config/less/lesskey";

      BAT_STYLE = "full";

      _FASD_DATA = "$HOME/.local/share/fasd/history";
      _FASD_SHELL = "dash";
    };
  };
}
