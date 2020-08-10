# System-wide configuation for tmux.

{ config, pkgs, ... } :

{
  programs = {
    tmux = {
      enable = true;
      shortcut = "Space";
      escapeTime = 10;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      baseIndex = 1;
      historyLimit = 10000;
      terminal = "screen-256color";
      extraConfig = ''
        # Use emacs-style keybindings for the status-line
        set -g status-keys emacs

        # Split windows with more intuitive keybindings
        bind | split-window -h
        bind - split-window -v

        bind C-- delete-buffer

        # Enable the mouse
        set -g mouse on

        # Set the default status bar style.
        set -g status-right ' #{?client_prefix,#[reverse]<Prefix>#[noreverse] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'
        set -g status-style 'fg=#87ceeb,bold,bg=#4e4e4e'
        set -g status-position top

        # Pane border style
        set -g pane-active-border-style 'fg=#ffffff,bg=#00FF7F'
      '';
    };
  };
}
