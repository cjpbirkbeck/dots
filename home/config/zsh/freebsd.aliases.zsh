################################################################################
#                                                                              #
# ALIASES:=For use with the FreeBSD userland                                   #
#                                                                              #
################################################################################

# Export relevant variables
# export CLICOLOR=true

# export MANWIDTH="tty"
# export MANCOLOR=true

# Moving between directories
alias p="popd"
alias d="dirs -pv"

# Ask when operating on multiple files.
alias rm="rm -I"
alias cp="cp -i"
alias mv="mv -i"

# Warn if symlink source does not exist and ask if target file already exists.
alias ln="ln -iw"
alias sl="ln -s"

# ls Aliases
# ls should have readable sizes, be coloured and list directories first.
alias ls="ls -h"

alias l="ls -l"    # List directories with a long format.
alias ll="ls -lA"  # List all directories with a long format
alias lt="ls -lt"  # List files by time (newest first)
alias lT="ls -ltr" # List files by time (oldest first)
alias lz="ls -lS"  # List files by size (largest first)
alias lZ="ls -lSr" # List files by size (smallest first)
alias la="ls -A"   # list hidden files

# Colourization
# These commands should always output their commands in colour.
alias tree="tree -C"
alias grep="grep --color=always"
alias fgrep="fgrep --color=always"
alias egrep="egrep --color=always"

# Program aliases
alias more="less"
alias dff="df -H -t nodevfs"
