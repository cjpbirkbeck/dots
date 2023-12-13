# System-wise configuration for zsh.

{ config, pkgs, ... } :

{
  users.defaultUserShell = pkgs.zsh;

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "root"
        ];
      };
      histSize = 2147483647;
      histFile = "$HOME/.local/state/zsh/history";
      setOptions = [
        # History options
        "APPEND_HISTORY"     # Sessions will append to history file.
        "INC_APPEND_HISTORY" # Session will incrementally append to the history file.
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
        "NOSHWORDSPLIT"      # Unquoted paramenter expansions are not splitted by fields.
        "LONGLISTJOBS"       # Job notifications are long.
        "NOTIFY"             # Immediately report bg job status.
        "NOHUP"              # Do not send hup signal to any running jobs.

        # Prompt
        "PROMPT_SUBST"       # Allow parameter expansion and command substitution.
      ];

      promptInit = ''
        TTY_BNAME="$(basename $(tty))"

        autoload -Uz vcs_info
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:git*' formats "%b(%7>>%i%<<)@%r%c%u"
        zstyle ':vcs_info:git*' actionformats "(%a|%m)@%r%c%u"
        zstyle ':vcs_info:git*' stagedstr "(+)"
        zstyle ':vcs_info:git*' unstagedstr "(!)"
        zstyle ':vcs_info:git*' get-revision true
        zstyle ':vcs_info:git*' check-for-changes true
        add-zsh-hook precmd vcs_info

        function precmd {
            psvar=()

            vcs_info

            # Set the terminal title
            print -Pn "''${__TERM_TITLE}"

            # Set up the vcs widget
            [[ -n $vcs_info_msg_0_ ]] && print -v 'psvar[1]' -Pr -- "$vcs_info_msg_0_"

            # Set up the nix-shell indicator "widget"
            if [[ "$IN_NIX_SHELL" = "pure" || "$IN_NIX_SHELL" = "impure" && "$HAS_NISH_PROMPT" != "yes" ]]; then
              RPROMPT="%B%F{white}%K{#5074bf}[NIXSH]%k%f%b''${RPROMPT}"
              export HAS_NISH_PROMPT="yes"
            fi
            if [[ -z "$IN_NIX_SHELL" ]]; then
              RPROMPT="''${RPROMPT/\%B\%F\{white\}\%K\{\#5074bf\}\[NIXSH\]\%k\%f\%b/}"
              export HAS_NISH_PROMPT=""
            fi
        }

        if test "$TERM" != "linux"; then
            PROMPT="%B%F{#FFFF00}["''${TTY_BNAME##*[a-z]}"]%f%F{#00FF7F}[%n@%M]%f%F{#87CEEB}[%(5~|%-1~/…/%3~|%4~)]%f%F{#FFFFFF}%(0#,#,$)%f%b "
            RPROMPT="%(1v,%B%F{#FFFFFF}%K{magenta}[%1v]%k%f%b,)%(?,,%B%F{#FFFFFF}%K{red}[%?]%k%f%b)%(1j,%B%F{#FFFFFF}%K{blue}[%j]%k%f%b,)%(3L,%B%F{#FFFFFF}%K{cyan}[%L]%k%f%b,)"

            # Write some info to terminal title.
            # This is seen when the shell prompts for input.
            # If using screen or tmux, then only use the directory name.
            # Otherwise, be a bit more verbose, show that it's zsh with is pts number,
            # along with if any jobs are in the background.
            case "$TERM" in
                screen* | tmux* )
                    __TERM_TITLE="\e]0;%~ %(1j,[%j],)\a"
                    ;;
                *)
                    __TERM_TITLE="\e]0;zsh [''${TTY_BNAME##*[a-z]}]: %~ %(1j,[%j],)\a"
                    ;;
            esac

            # Write command and args to terminal title.
            # This is seen while the shell waits for a command to complete.
            function preexec {
                printf "\033]0;%s\a" "$1"
            }

        else
            PROMPT="%B%F{red}[%t]%f%F{yellow}["''${TTY_BNAME##*[a-z]}"]%f%F{green}[%n@%M]%f%F{blue}[%(5~|%-1~/…/%3~|%4~)]%f%F{white}%(0#,#,$)%f%b "
            RPROMPT="%(1v,%B%F{#FFFFFF}%K{magenta}[%1v]%k%f%b,)%(?,,%B%F{white}%K{red}[%?]%k%f%b)%(1j,%B%F{white}%K{blue}[%j]%k%f%b,)%(3L,%B%F{#FFFFFF}%K{cyan}[%L]%k%f%b,)"
        fi

      # Change prompt when using zsh's vi command mode
      zle-keymap-select () {
          if [[ $KEYMAP == vicmd ]]; then
              RPROMPT="%B%F{white}%K{green}[CMD]%k%f%b''${RPROMPT}"
          else
              RPROMPT="''${RPROMPT/\%B\%F\{white\}\%K\{green\}\[CMD\]\%k\%f\%b/}"
          fi
          zle reset-prompt
      }

      zle -N zle-keymap-select

      # Remove any changes to the prompt when set up a new line.
      # Without it, the [CMD] prompt doesn't disappear you execute within vi command mode.
      # Does not quite work, you have enter another line to work.
      zle-line-init () {
        RPROMPT="''${RPROMPT/\%B\%F\{white\}\%K\{green\}\[CMD\]\%k\%f\%b/}"
      }

      zle -N zle-line-init
      '';

      interactiveShellInit = ''
        stty -ixon    # Disable C-s and C-q in terminals

        bindkey -e    # Use Emacs-like keybindings

        # Set alt-backspace to delete words up to slash.
        # Use alt-control-h to delete the entire word.
        function slash-backwards-kill-word {
            local WORDCHARS="''${WORDCHARS:s@/@}"
            zle backward-kill-word
        }
        zle -N slash-backwards-kill-word
        bindkey '\e^?' slash-backwards-kill-word

        # Set alt-e to edit current line within a text editor.
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^[e' edit-command-line

        # The following was from the Arch Wiki.
        # create a zkbd compatible hash;
        # to add other keys to this hash, see: man 5 terminfo
        typeset -g -A key

        # Search history for lines that match the current line.
        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        # Setup keys accordingly
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

        # Get help for various subcommands.
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

        # Partial completion suggestions
        zstyle ':completion:*' list-suffixes
        zstyle ':completion:*' expand prefix suffix

        # Add digraph insertion support.
        # Insert with alt-k
        autoload -Uz insert-composed-char
        zle -N insert-composed-char
        bindkey '^[k' insert-composed-char
      '';
    };
  };
}
