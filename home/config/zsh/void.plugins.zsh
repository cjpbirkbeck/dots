################################################################################
#                                                                              #
# PLUGINS: For use with Void Linux                                             #
#                                                                              #
################################################################################

# Distro specific aliases
alias xbpsq="xbps-query"
alias xpbsq="xbps-query"
alias xbpsi="sudo xbps-install"
alias xpbsi="sudo xbps-install"
alias xbpsr="sudo xbps-remove"
alias xpbsr="sudo xbps-remove"

alias xbpsqr="xbps-query -R"
alias xpbsqr="xbps-query -R"
alias xbpsu="sudo xbps-install -Su"
alias xpbsu="sudo xbps-install -Su"

# Get common functions
test -e  $HOME/.local/share/shell/functions.sh && \
    source $HOME/.local/share/shell/functions.sh

if test -e /usr/share/zsh/plugins/zsh-autosuggestions/; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

if test -e /usr/share/doc/fzf; then
    source /usr/share/doc/fzf/completion.zsh
    source /usr/share/doc/fzf/key-bindings.zsh

    export FZF_ALT_C_OPTS="--ansi --preview='ls -gAGh --color --group-directories-first {}'"
    # TODO: Finish revising peekat so it can serve as a file previewer here.
    export FZF_CTRL_T_OPTS="--preview='bat {}'"
fi

test -e /usr/share/bash-completion && autoload -U +X bashcompinit && bashcompinit

# This needs to be loaded last.
test -e /usr/share/zsh/plugins/zsh-syntax-highlighting && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
