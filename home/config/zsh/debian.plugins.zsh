################################################################################
#                                                                              #
# PLUGINS: For use with Debian                                                 #
#                                                                              #
################################################################################

# Distro-specific aliases

alias aptuu="sudo apt update --yes && sudo apt upgrade --yes"

# Get common functions
test -e  $HOME/.local/share/shell/functions.sh && \
    source $HOME/.local/share/shell/functions.sh

if test -e /usr/share/zsh-autosuggestions/; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

if test -e /usr/share/examples/fzf/shell; then
    source /usr/share/examples/fzf/shell/completion.zsh
    source /usr/share/examples/fzf/shell/key-bindings.zsh

    export FZF_ALT_C_OPTS="--ansi --preview='ls -gAGh --color --group-directories-first {}'"
    # TODO: Finish revising peekat so it can serve as a file previewer here.
    export FZF_CTRL_T_OPTS="--preview='bat {}'"
fi

test -e /usr/share/bash-completion && autoload -U +X bashcompinit && bashcompinit

# This needs to be loaded last.
test -e /usr/share/zsh-syntax-highlighting && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
