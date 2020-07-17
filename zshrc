################################################################################
#                                                                              #
# ZSHRC: settings for interactive zsh sessions                                 #
#                                                                              #
################################################################################

### General ###

stty -ixon # Disable C-s and C-q in terminals.
KERNEL="$(uname)"

test $KERNEL = "Linux" && PREFIX="/usr/share/zsh/plugins"
test $KERNEL = "FreeBSD" && PREFIX="/usr/local/share"
test $KERNEL = "OpenBSD" && PREFIX="/usr/local/share"

### Keybindings ###

bindkey -e # Use Emacs-like keybindings.
autoload -U select-word-style && select-word-style shell

### Prompt and Terminal Title ###

# Outside of a virtual console, the tty is usually /dev/pts/X, so $TTY_BNAME should be a number only.
# Vitual consoles should be ttyN (Linux) or ttyvN (FreeBSD)
TTY_BNAME="$(basename $(tty))"

# Test if shell is running in a virtual console (without a X server).
# This should work for Linux and FreeBSD, have to test with the other BSDs.
if [ $TERM = "linux" -o "${TTY_BNAME%%[0-9]*}" = "ttyv" ]; then
    PROMPT="%B%F{red}[%t]%f%F{green}[%n@%M]%f%F{blue}[%(5~|-1~/…/%3~|%4~)]%f%F{white}%(0#,#,$)%f%b "
    RPROMPT="%(?,,%B%F{white}%K{red}[%?]%k%f%b)%(1j,%B%F{white}%K{blue}[%j]%k%f%b,)"
else
    PROMPT="%B%F{#FFFF00}[$TTY_BNAME]%f%F{#00FF7F}[%n@%M]%f%F{#87CEEB}[%(5~|%-1~/…/%3~|%4~)]%f%F{#FFFFFF}%(0#,#,$)%f%b "
    RPROMPT="%(?,,%B%F{#FFFFFF}%K{red}[%?]%k%f%b)%(1j,%B%F{#FFFFFF}%K{blue}[%j]%k%f%b,)"

    # Write some info to terminal title.
    # This is seen when the shell prompts for input.
    function precmd {
        print -Pn "\e]0;zsh [$TTY_BNAME]:%~ %(1j,[%j],)\a"
    }
    # Write command and args to terminal title.
    # This is seen while the shell waits for a command to complete.
    function preexec {
        printf "\033]0;%s\a" "$1"
    }
fi

### Directory navigation ###

setopt AUTO_CD            # If not command, try to cd.
setopt AUTO_PUSHD         # Push old directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS  # Ignore multiple copies on the stack.

### History ###

HISTSIZE=2147483647
SAVEHIST=HISTSIZE
HISTFILE=$HOME/.local/share/zsh/history

setopt HIST_IGNORE_SPACE  # Ignores commands with a space.
setopt HIST_REDUCE_BLANKS # Removes blanks from history when not needed.
setopt SHARE_HISTORY      # History shared between sessions.

# Search for lines matching the current input, if present.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

### Globing and Expansion ###

setopt HASH_LIST_ALL      # Hash the entire command path FIRST.
setopt EXTENDED_GLOB      # The characters #, ~ and ^ are treated as part of the pattern.
setopt NOSHWORDSPLIT      # Unquoted paramenter expansions are not splitted by fields.
setopt LONGLISTJOBS       # Job notifications are long.
setopt NOTIFY             # Immediately report bg job status.
setopt NOHUP              # Do not send hup signal to any running jobs.

### Completions ###

autoload -Uz compinit && compinit                        # Enable completion
zstyle ':completion:*' menu select                       # Enables a navigatable menu
zstyle ':completion::complete:*' gain=privileges 1       # Enables completion with sudo/doas
zstyle ':completion:*:default' list-colors 'fi=97:di=94' # Colour regular files as white, dirs as blue

# Cache completions; useful for package managers
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $HOME/.cache/zsh/

### Source Plugins ###

if test -e "${PREFIX}"/zsh-autosuggestions/; then
    source "${PREFIX}"/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_USE_ASYNC=true         # Get suggestions asynchronously
fi

test -e "${PREFIX}"/zsh-navigation-tools && \
    source "${PREFIX}"/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh

unset KERNEL TTY_BNAME

# This needs to be loaded last
test -e "${PREFIX}"/zsh-syntax-highlighting && \
    source "${PREFIX}"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
