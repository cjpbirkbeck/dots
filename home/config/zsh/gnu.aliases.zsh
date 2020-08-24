################################################################################
#                                                                              #
# ALIASES: For use with the GNU/LInux userland                                 #
#                                                                              #
################################################################################

# File system aliases

# Enable intractive mode by default.
alias rm="rm -I --preserve-root"
alias cp="cp -i"
alias mv="mv -i"
alias ln="ln -i"

# Preserve root from ch* commands.
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"

# Alias for making symlinks.
alias sl="ln -s"

# Quickly pop directory list.
alias p="popd"
alias d="dirs -pv"

# ls Aliases
# ls should have readable sizes, be coloured and list directories first.
alias ls="ls --human-readable --color=auto --group-directories-first"

alias l= "ls -l"   # List directories with a long format.
alias ll="ls -lA"  # List all directories with a long format
alias lt="ls -lt"  # List files by time (newest first)
alias lT="ls -ltr" # List files by time (oldest first)
alias lx="ls -lXB" # List files by file extension
alias lz="ls -lS"  # List files by size (largest first)
alias lz="ls -lSr" # List files by size (smallest first)
alias la="ls -A"   # list hidden files

# Appearance

# Colourize commands.
alias less="less -R"
alias tree="tree -C --dirsfirst"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Program aliases
alias more="less"
alias dff="df -hH -x tmpfs -x devtmpfs"
