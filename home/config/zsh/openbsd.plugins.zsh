
if test -e /usr/local/share/examples/fzf/shell; then
    source /usr/local/share/examples/fzf/shell/completion.zsh
    source /usr/local/share/examples/fzf/shell/key-bindings.zsh

    export FZF_ALT_C_OPTS="--ansi --preview='ls -lAh --color=always {} | cut -d \" \" -f 1-3 -f 8-'"
    # TODO: Finish revising peekat so it can serve as a file previewer here.
    export FZF_CTRL_T_OPTS="--preview='bat {}'"
fi

