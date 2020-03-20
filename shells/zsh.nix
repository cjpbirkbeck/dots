# System-wise configuration for zsh.

{ config, pkgs, ... } :

{

  users.defaultUserShell = pkgs.zsh;

  environment = {
    variables = {
      ZDOTDIR = "$HOME/.config/zsh";
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          # "cursor"
        ];
      };
      histSize = 2147483647;
      histFile = "$HOME/.local/share/zsh/history";

      setOptions = [
        # History options
        "APPEND_HISTORY"     # Sessions will append to history file.
        "SHARE_HISTORY"      # Session imports from history file.
        "EXTENDED_HISTORY"   # Saves history with UNIX epoch timestamp and duration.
        "HISTIGNOREALLDUPS"  # Ignore immediate duplicated entries.
        "HIST_IGNORE_SPACE"  # Ignores commands with a space.
        "HIST_REDUCE_BLANKS" # Removes blanks from history when not needed.

        # Directory options
        "AUTO_CD"            # If not command, try to cd.
        "AUTO_PUSHD"         # Push old directory onto the directory stack.
        "PUSHD_IGNORE_DUPS"  # Ignore multiple copies on the stack.

        # Globing and expansion
        "HASH_LIST_ALL"      # Hash the entire command path FIRST.
        "EXTENDED_GLOB"      # The characters #, ~ and ^ are treated as part of the pattern.
        "NOSHWORDSPLIT"
        "LONGLISTJOBS"
        "NOTIFY"             # Immediately report bg job status.
        "NOHUP"              # Do not send hup signal to any running jobs.

        # Prompt
        "PROMPT_SUBST"       # Allow parameter expansion and command substitution.
      ];

      promptInit = ''
        if [ $TERM = "linux" ]; then
          PROMPT="%B%F{red}[%t]%f%F{green}[%n@%M]%f%F{blue}[%~]%f%F{white}%(0#,#,$)%f%b "
        else
          PROMPT="%B%F{#00FF7F}[%n@%M]%f%F{#87CEEB}[%~]%f%F{white}%(0#,#,$)%f%b "
        fi

        RPROMPT="%(?,,%B%F{white}%K{red}[%?]%k%f%b)%(1j,%B%F{white}%K{blue}[%j]%k%f%b,)"
      '';

      interactiveShellInit = ''
        stty -ixon    # Disable C-s and C-q in terminals

        bindkey -e

        # create a zkbd compatible hash;
        # to add other keys to this hash, see: man 5 terminfo
        typeset -g -A key

        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        key[Home]="''${terminfo[khome]}"
        key[End]="''${terminfo[kend]}"
        key[Insert]="''${terminfo[kich1]}"
        key[Backspace]="''${terminfo[kbs]}"
        key[Delete]="''${terminfo[kdch1]}"
        key[Up]="''${terminfo[kcuu1]}"
        key[Down]="''${terminfo[kcud1]}"
        key[Left]="''${terminfo[kcub1]}"
        key[Right]="''${terminfo[kcuf1]}"
        key[PageUp]="''${terminfo[kpp]}"
        key[PageDown]="''${terminfo[knp]}"
        key[ShiftTab]="''${terminfo[kcbt]}"

        # setup key accordingly
        [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"      beginning-of-line
        [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"       end-of-line
        [[ -n "''${key[Insert]}"    ]] && bindkey -- "''${key[Insert]}"    overwrite-mode
        [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}" backward-delete-char
        [[ -n "''${key[Delete]}"    ]] && bindkey -- "''${key[Delete]}"    delete-char
        [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"        up-line-or-beginning-search
        [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"      down-line-or-beginning-search
        [[ -n "''${key[Left]}"      ]] && bindkey -- "''${key[Left]}"      backward-char
        [[ -n "''${key[Right]}"     ]] && bindkey -- "''${key[Right]}"     forward-char
        [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"    beginning-of-buffer-or-history
        [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"  end-of-buffer-or-history
        [[ -n "''${key[ShiftTab]}"  ]] && bindkey -- "''${key[ShiftTab]}"  reverse-menu-complete

        # Finally, make sure the terminal is in application mode, when zle is
        # active. Only then are the values from $terminfo valid.
          if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
              autoload -Uz add-zle-hook-widget
              function zle_application_mode_start {
                  echoti smkx
              }
            function zle_application_mode_stop {
                echoti rmkx
            }
            add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
            add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
          fi

        autoload -Uz run-help
        unalias run-help
        alias help=run-help

        autoload -Uz run-help-git
        autoload -Uz run-help-ip
        autoload -Uz run-help-openssl
        autoload -Uz run-help-p4
        autoload -Uz run-help-sudo
        autoload -Uz run-help-svk
        autoload -Uz run-help-svn

        # Completion
        # Allows for menu completions.
        zstyle ':completion:*' menu select

        # Formats descriptions and warnings
        zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
        zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

        # partial completion suggestions
        zstyle ':completion:*' list-suffixes
        zstyle ':completion:*' expand prefix suffix

        # fasd hooks
        eval "$(fasd --init auto)"

        # Load fzf completions
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh

        export PATH="$HOME/.local/bin/:$PATH"
      '';

    };
  };
}
