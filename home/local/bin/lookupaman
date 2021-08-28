#!/usr/bin/env dash
# Open a tmux split, and use fzf to fuzzy search those pages, then open the man pages in that pane.

search_sections="1,4,5,6,7"

tmuxcmd="fzf-tmux"
[ -n "$FROM_TMUX" ] && tmuxcmd="fzf"

manpage="$(apropos -s "${search_sections}" . | "$tmuxcmd" --prompt="Man ${search_sections}> " --preview="man {1}")"

[ -n "$manpage" ] && section="$(echo "${manpage}" | sed -E 's_.*\((.*)\).*_\1_g')" && man "$section" "${manpage%% *}"
