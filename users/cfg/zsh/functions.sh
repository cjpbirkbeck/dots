# Write to the terminal window.
case $TERM in
    (*xterm* | rxvt)

    # Write some info to terminal title.
    # This is seen when the shell prompts for input.
        function precmd {
            print -Pn "\e]0;zsh %(1j,%j job%(2j|s|); ,)%~\a"
        }
    # Write command and args to terminal title.
    # This is seen while the shell waits for a command to complete.
        function preexec {
            printf "\033]0;%s\a" "$1"
        }

    ;;
esac

# Open the Nix store when given a command. Note that is works only for a command.
function _nix_store_open {
if [ -n "$1" ]; then
  npath="$(nix path-info "$(command -v "$1")")"

  cd "$npath" || return
else
  echo "No valid argument. exiting."
  return 1
fi
}

# Make a directory and change into it.
function _mkdir_cd {
    if [ $# -eq 1 ]; then
        mkdir -p "$1" && cd "$1" || return 1
    else
        echo "Incorrect arguments." && return 1
    fi
}

alias ncd="_nix_store_open"
alias md="_mkdir_cd"
