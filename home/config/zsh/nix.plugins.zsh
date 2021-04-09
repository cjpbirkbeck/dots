# Plugins using Linux with nix (not NixOS!)
# Currently being used with WSL.

# Turn off the bell.
unsetopt BEEP
unsetopt LIST_BEEP

# Alias less so it doesn't activate the bell.
export LESS="$LESS -R -Q"

# Get common functions
test -e  $HOME/.local/share/shell/functions.sh && \
    source $HOME/.local/share/shell/functions.sh

if test -e $HOME/.nix-profile/share/zsh-autosuggestions/; then
    source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

if test -e $HOME/.nix-profile/share/fzf/; then
    source $HOME/.nix-profile/share/fzf/completion.zsh
    source $HOME/.nix-profile/share/fzf/key-bindings.zsh

    export FZF_ALT_C_OPTS="--ansi --preview='ls -gAGh --color --group-directories-first {}'"
    export FZF_CTRL_T_OPTS="--preview='$HOME/.local/bin/peekat {}'"
fi

# Use native distro's bash-completions.
test -e /usr/share/bash-completion && autoload -U +X bashcompinit && bashcompinit

# This needs to be loaded last.
test -e $HOME/.nix-profile/share/zsh-syntax-highlighting && \
    source $HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
