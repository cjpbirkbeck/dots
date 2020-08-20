################################################################################
#                                                                              #
# PLUGINS: For use with the FreeBSD directory heirarchy                        #
#                                                                              #
################################################################################

# Get common functions
source $HOME/.local/share/shell/functions.sh

if test -e /usr/local/share/zsh-autosuggestions/; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

if test -e /usr/local/share/examples/fzf/shell; then
    source /usr/local/share/examples/fzf/shell/completion.zsh
    source /usr/local/share/examples/fzf/shell/key-bindings.zsh
fi

test -e /usr/local/share/bash-completion && autoload -U +X bashcompinit && bashcompinit

# This needs to be loaded last.
test -e /usr/local/share/zsh-syntax-highlighting && \
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
