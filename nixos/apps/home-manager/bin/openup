#!/usr/bin/env bash
# Opens files in a new window, given first the file extension and then the mimetype.

examine_file_path() {
    local path="${1}"

    FILE_PATH="$path"
    FILE_EXT="${FILE_PATH##*.}"
    FILE_EXT_LOWER=$(echo "${FILE_EXT}" | tr '[:upper:]' '[:lower:]')
}

while test $# -gt 0; do
    if test $# -eq 1; then
        examine_file_path "${1}"
        break
    fi

    case "${1}" in
        "-r"|"--gui")
            GUI=true
            shift
            ;;
        "-p"|"--playlist")
            PLAYLIST=true
            shift
            ;;
        "--")
            shift
            examine_file_path "${1}"
            break
            ;;
        *)
            exit 1
            ;;
    esac
done

function open_text() {
    if test $GUI; then
        setsid nvim-qt "${FILE_PATH}" & disown
    else
        nvim "${FILE_PATH}"
    fi
}

function open_document_viewer() {
    zathura --fork "${FILE_PATH}" 2>&1 /dev/null
}

function open_office_document() {
    setsid --fork libreoffice "${FILE_PATH}" & 2>&1 /dev/null
}

function open_image() {
    setsid --fork sxiv -a "${FILE_PATH}" 2>&1 /dev/null
}

function open_audio(){
    if test $PLAYLIST; then
        mpc add "${FILE_PATH}"
    else
        open_multimedia
    fi
}

function open_multimedia() {
    setsid --fork mpv --player-operation-mode=pseudo-gui "${FILE_PATH}" 2>&1 /dev/null
}

function open_unknown() {
    setsid --fork xdg-open "${FILE_PATH}" 2>&1 /dev/null
}

function handle_extension() {
    ext="${1}"

    case "$ext" in
        txt|sh|md|markdown|org)
            open_text
            ;;
        pdf|djvu|ps|epub)
            open_document_viewer
            ;;
        odm|odp|ods|odt|odb|odf|odg|doc|docx|xls|xlsx|ppt|pptx)
            open_office_document
            ;;
        jpg|jpeg|gif|bmp|png)
            open_image
            ;;
        wma|ogg|mp3|mp4)
            open_audio
            ;;
        webm|avi|mkv)
            open_multimedia
            ;;
    esac
    exit 0
}

function handle_mime() {
    mime="${1}"

    case "$mime" in
        text/* )
            open_text
            ;;
        application/vnd.oasis.opendocument.*|application/msword)
            open_office_document
            ;;
        application/epub+zip|application/pdf)
            open_document_viewer
            ;;
        images/*)
            open_image
            ;;
        audio/*)
            open_audio
            ;;
        video/*|application/octet-stream)
            open_multimedia
            ;;
        *)
            open_unknown
            ;;
    esac
    exit 0
}

handle_extension "${FILE_EXT_LOWER}"
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_mime "${MIMETYPE}"
>&2 echo "Unknown file extension and file type. Exiting."
exit 1
