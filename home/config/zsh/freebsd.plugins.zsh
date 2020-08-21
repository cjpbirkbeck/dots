################################################################################
#                                                                              #
# PLUGINS: For use with the FreeBSD directory heirarchy                        #
#                                                                              #
################################################################################

# Get common functions
test -e  $HOME/.local/share/shell/functions.sh && \
    source $HOME/.local/share/shell/functions.sh

if test -e /usr/local/share/zsh-autosuggestions/; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

if test -e /usr/local/share/examples/fzf/shell; then
    source /usr/local/share/examples/fzf/shell/completion.zsh
    source /usr/local/share/examples/fzf/shell/key-bindings.zsh

    export FZF_ALT_C_OPTS="--ansi --preview='ls -lAh --color=always {} | cut -d \" \" -f 1-3 -f 8-'"
    # TODO: Finish revising peekat so it can serve as a file previewer here.
    export FZF_CTRL_T_OPTS="--preview='bat {}'"
fi

test -e /usr/local/share/bash-completion && autoload -U +X bashcompinit && bashcompinit

# This needs to be loaded last.
test -e /usr/local/share/zsh-syntax-highlighting && \
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
