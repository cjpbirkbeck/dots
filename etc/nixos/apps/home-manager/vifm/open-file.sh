#!/usr/bin/env bash
# Opens files in a new window, given first the file extension and then the mimetype.

# Arguments
FILE_PATH="${1}"
FILE_EXT="${FILE_PATH##*.}"
FILE_EXT_LOWER=$(echo "${FILE_EXT}" | tr '[:upper:]' '[:lower:]')

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
        ogg|mp3|mp4|wma|webm|avi|mkv)
            open_multimedia
            ;;
    esac
}

function handle_mime() {
    mime="${1}"

    case "$mime" in
        text/*)
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
        video/*|audio/*|application/octet-stream)
            open_multimedia
            ;;
        *)
            open_unknown
            ;;
    esac
    exit 0
}

function open_text() {
    $EDITOR "${FILE_PATH}"
}

function open_document_viewer() {
    zathura --fork "${FILE_PATH}"
    exit 0
}

function open_office_document() {
    setsid libreoffice "${FILE_PATH}" &
    exit 0
}

function open_image() {
    setsid --fork sxiv -a "${FILE_PATH}"
    exit 0
}

function open_multimedia() {
    setsid --fork mpv --player-operation-mode=pseudo-gui "${FILE_PATH}"
    exit 0
}

function open_unknown() {
    setsid --fork xdg-open "${FILE_PATH}"
}

handle_extension "${FILE_EXT_LOWER}"
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_mime "${MIMETYPE}"
>&2 echo "Unknown file extension and file type. Exiting."
exit 1
