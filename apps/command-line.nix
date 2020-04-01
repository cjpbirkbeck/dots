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

      rsync             # Simple archival program
      rclone            # rsync for cloud storage
      borgbackup        # Deduplication backup tool

      neofetch          # An "About" screen for the terminal
      ddgr              # Search DuckDuckGo from the command line
      pdd               # Date/time calculator
      gcal              # Prints out almost any calendar and some holidays.
      translate-shell   # Search for translations (e.g. Google, Yandex) from the command line.
      qrencode          # Prints out QR codes, when given a string of letters.

      ffmpeg            # Video encoder
      ffmpegthumbnailer # Create video thumbnails
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
