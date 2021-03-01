#!/usr/bin/env zsh
# Search through files and open them in a new window, as specified by either the extension or mime type.

export PEEKAT_WITH_FZF=true

FILE_EXTS="\.(ogg|mp[3-4]|wma|webm|txt|md|markdown|org|epub|pdf|ps|djvu|png|jpe?g|gif|bmp|avi|mkv)$"

selected="$(fd --type file "$FILE_EXTS" $HOME/{audio,docs,ref,images,videos,dls} | \
    fzf --prompt="Files> " --history="$HOME/.cache/fzf/find-file-history" \
    --reverse --preview="$HOME/.local/bin/peekat {} " --preview-window=right:wrap)"

test -n "$selected" && "$HOME/.config/awesome/bin/open-file.sh" "$selected"
