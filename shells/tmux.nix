# System-wide configuation for tmux.

{ config, pkgs, ... } :

{
  programs = {
    tmux = {
      enable = true;
      shortcut = "q";
      keyMode = "vi";
      baseIndex = 1;
      historyLimit = 10000;
      terminal = "tmux-256color";
      extraTmuxConf = ''
        # Set the default status bar style.
        set -g status-right ' #{?client_prefix,#[reverse]<Prefix>#[noreverse] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'
        set -g status-style fg=white,bold,bg=blue
        set -g status-position top
      '';
    };
  };
}
