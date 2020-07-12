# Configure interactive sessions with zsh.

# Set prompt
if [ $TERM = "linux" ]; then
    # Within the linux console, display show the time in red.
    PROMPT="%B%F{red}[%t]%f%F{green}[%n@%M]%f%F{blue}[%(5~|-1~/…/%3~|%4~)]%f%F{white}%(0#,#,$)%f%b "
    RPROMPT="%(?,,%B%F{white}%K{red}[%?]%k%f%b)%(1j,%B%F{white}%K{blue}[%j]%k%f%b,)"
else
    # Outside of the linux console, the tty is usually /dev/pts/X, so $pts_id should be a number only.
    pts_id="$(basename $(tty))"
    # Print out the pts as simple method of distingishing two terminal sessions.
    PROMPT="%B%F{#FFFF00}[$pts_id]%f%F{#00FF7F}[%n@%M]%f%F{#87CEEB}[%(5~|%-1~/…/%3~|%4~)]%f%F{#FFFFFF}%(0#,#,$)%f%b "
    RPROMPT="%(?,,%B%F{#FFFFFF}%K{red}[%?]%k%f%b)%(1j,%B%F{#FFFFFF}%K{blue}[%j]%k%f%b,)"
fi

# History
HISTSIZE=2147483647
SAVEHIST=HISTSIZE
HISTFILE=$HOME/.local/share/zsh/history

stty -ixon    # Disable C-s and C-q in terminals

bindkey -e    # Use Emacs-like keybindings
autoload -U select-word-style
select-word-style bash

# The follow was from the Arch Wiki.
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-beginning-search
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-beginning-search
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
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

# Load syntax highlighting
