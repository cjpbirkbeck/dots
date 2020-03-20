# System-wide configuation for tmux.

{ config, pkgs, ... } :

{
  programs = {
    tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      historyLimit = 10000;
      terminal = "tmux-256color";
      extraTmuxConf = ''
        # Set the default status bar style.
        set -g status-right ' #{?client_prfix,#[reverse]<Prefix>#[noreverse] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'
        set -g status-style fg=white,bold,bg=blue
        set -g status-position top

        # Set prefix to Alt/Meta-space(bar). I found it is the most convient of possible shortcuts.
        unbind C-b
        set -g prefix M-space
        bind M-space send-prefix
      '';
    };
  };
}
