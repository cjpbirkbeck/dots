if test -e $HOME/code/zsh-autosuggestions/; then
    source $HOME/code/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

if test -e /usr/local/share/examples/fzf/shell; then
    autoload _fzf_key_bindings _fzf_completion && \
        _fzf_key_bindings && \
        _fzf_completion

    export FZF_ALT_C_OPTS="--ansi --preview='ls -lAh --color=always {} | cut -d \" \" -f 1-3 -f 8-'"
    # TODO: Finish revising peekat so it can serve as a file previewer here.
    export FZF_CTRL_T_OPTS="--preview='cat {}'"
fi

# test -e /usr/local/share/bash-completion && autoload -U +X bashcompinit && bashcompinit

# This needs to be loaded last.
test -e $HOME/code/zsh-syntax-highlighting && \
    source $HOME/code/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
