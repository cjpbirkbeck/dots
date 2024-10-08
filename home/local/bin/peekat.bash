#!/usr/bin/env bash
# Generates a textual previews of a file, based on its file extension and mimetype.
# Otherwise, it prints out some file information.

# Based off Ranger's scope.sh and a suggested revision for lf.
# Latest Ranger scope.sh: https://github.com/ranger/ranger/blob/master/ranger/data/scope.sh
# Suggested lf scope.sh: https://github.com/gokcehan/lf/wiki/Ranger

set -C -f
IFS=$'\n'
WINDOW_WIDTH="${COLUMNS:=80}"
# Hack for working with fzf, as $FZF_PREVIEW_COLUMNS doesn't seem to work.
test -n "$PEEKAT_WITH_FZF" && WINDOW_WIDTH=$(( COLUMNS / 2 - 6 ))
# Hack for working with vifm, passing preview window size as the second argument.
test -n "$PEEKAT_WITH_VIFM" && WINDOW_WIDTH="${2}"
PAGE_LIMIT=10

# Process the file path and find its file extension.
examine_file_path() {
    local path="${1}"

    FILE_PATH="$path"
    FILE_EXT="${FILE_PATH##*.}"
    FILE_EXT_LOWER="$(echo '${FILE_EXT}' | tr '[:upper:]' '[:lower:]')"
}

# Print out dashes to fill the screen.
printbreak() {
    for ((i=0; i<WINDOW_WIDTH; i++)); do printf '—'; done
    printf '\n'
}

# Various processing functions for converting various file formats into useful text-based representations.

process_pdf () {
    if command -v pdftotext > /dev/null ; then
        pdftotext -l "${PAGE_LIMIT}" -nopgbrk -q -- "${FILE_PATH}" - | fold -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer "pdftotext"
    fi
    printbreak
    if command -v exiftool ; then
        exiftool "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer exiftool
    fi
    exit 0
}

process_epub () {
    # NOTE: pandoc is quite slow, slower than should allowed for a script
    # like this. It should be replace with something like epub2txt2, if I
    # can get it to work.
    if command -v pandoc > /dev/null ; then
        pandoc -i "${FILE_PATH}" --to=plain -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer "pandoc"
    fi
    printbreak
    if command -v exiftool ; then
        exiftool "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer exiftool
    fi
    exit 0
}

process_compressed() {
    if command -v atool > /dev/null ; then
        atool --list -- "${FILE_PATH}"
    else
        handle_missing_viewer "atool"
    fi
    exit 0
}

process_torrent() {
    if command -v transmission-show > /dev/null ; then
        transmission-show -- "${FILE_PATH}"
    else
        handle_missing_viewer "transmission-show"
    fi
    exit 0
}

process_odt() {
    if command -v odt2txt > /dev/null ; then
        odt2txt --width="${WINDOW_WIDTH}" "${FILE_PATH}"
    else
        handle_missing_viewer "odt2txt"
    fi
    exit 0
}

process_ms_word() {
    if command -v catdoc > /dev/null ; then
        catdoc "${FILE_PATH}"
    else
        handle_missing_viewer "catdoc"
    fi
    exit 0
}

process_ms_wordx() {
    if command -v catdocx > /dev/null ; then
        catdocx "${FILE_PATH}"
    else
        handle_missing_viewer "catdocx"
    fi
    exit 0
}

process_html() {
    if command -v w3m > /dev/null ; then
        w3m -dump "${FILE_PATH}"
    else
        echo "Cannot generate file with w3m. Showing raw text instead."
    fi
    printbreak
    printf 'SOURCE:\n'
    process_struct_text
    exit 0
}

process_struct_text() {
    if command -v bat > /dev/null ; then
        bat --style="numbers,changes" --color=always --italic-text=always "${FILE_PATH}"
    else
        cat -n "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    fi
    exit 0
}

process_json () {
    if command -v bat > /dev/null && command -v js > /dev/null ; then
        jq '.' -C "${FILE_PATH}" | \
            bat --style="numbers,changes" --color=always --italic-text=always "${FILE_PATH}"
    else
        cat -n "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    fi
    printbreak
    printf 'SOURCE:\n'
    process_struct_text
    exit 0
}

process_markdown () {
    if command -v bat > /dev/null && command -v glow > /dev/null; then
        glow --style auto | \
            bat --style="numbers,changes" --color=always --italic-text=always "${FILE_PATH}"
    else
        cat -n "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    fi
    printbreak
    printf 'SOURCE:\n'
    process_struct_text
    exit 0
}

process_image() {
    if command -v img2txt > /dev/null ; then
        img2txt -W "${WINDOW_WIDTH}" "${FILE_PATH}" 2>/dev/null
    else
        echo "Cannot find img2txt to generate text-based preview."
    fi
    printbreak
    if command -v mediainfo ; then
        mediainfo "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer "mediainfo"
    fi
    exit 0
}

process_multimedia() {
    if command -v mediainfo > /dev/null ; then
        mediainfo "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer "mediainfo"
    fi
    printbreak
    if command -v exiftool ; then
        exiftool "${FILE_PATH}" | fold -s -w "${WINDOW_WIDTH}"
    else
        handle_missing_viewer exiftool
    fi
    exit 0
}

process_ms_excel() {
    if command -v xls2csv > /dev/null ; then
        xls2csv -- "${FILE_PATH}"
    else
        handle_missing_viewer "xls2csv"
    fi
    exit 0
}

process_ms_excelx() {
    if command -v xlsx2csv > /dev/null ; then
        xlsx2csv -- "${FILE_PATH}"
    else
        handle_missing_viewer "xlsx2csv"
    fi
    exit 0
}

process_directory() {
    ls -l --group-directories-first --color=always --human-readable "${FILE_PATH}"
    exit 0
}

process_executable() {
    if command -v readelf > /dev/null; then
        readelf --file-header "${FILE_PATH}"
        exit 0
    else
        handle_missing_viewer "readelf"
    fi
}

handle_extension() {
    case "${FILE_EXT_LOWER}" in
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            process_compressed
            ;;
        png|jpg|jpeg)
            process_image
            ;;
        nix|md|markdown|txt)
            process_struct_text
            ;;
        json)
            process_json
            ;;
        pdf)
            process_pdf
            ;;
        epub)
            process_epub
            ;;
        torrent)
            process_torrent
            ;;
        odt)
            process_odt
            ;;
        htm|html|xhtml)
            process_html
            ;;
        doc)
            process_ms_word
            ;;
        docx)
            process_ms_wordx
            ;;
        xls)
            process_ms_excel
            ;;
        xlsx)
            process_ms_excelx
            ;;
    esac
}

handle_mime() {
    local MIMETYPE="${1}"

    case "${MIMETYPE}" in
        application/javascript | text/* | */*xml)
            process_struct_text
            ;;
        application/msword)
            process_ms_word
            ;;
        application/json)
            process_json
            ;;
        application/vnd.oasis.opendocument.text|application/vnd.oasis.opendocument.spreadsheet|\
        application/vnd.oasis.opendocument.presentation)
            process_odt
            ;;
        application/vnd.openxmlformats-officedocument.wordprocessingml.document)
            process_ms_wordx
            ;;
        application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
            process_ms_excelx
            ;;
        application/pdf)
            process_pdf
            ;;
        application/epub+zip)
            process_epub
            ;;
        image/*)
            process_image
            ;;
        video/*|audio/*|application/octet-stream)
            process_multimedia
            ;;
        application/gzip|application/x-tar|application/zip)
            process_compressed
            ;;
        inode/directory)
            process_directory
            ;;
        application/x-executable)
            process_executable
            ;;
        inode/x-empty)
            echo "Empty file" && exit 0
            ;;
    esac
}

handle_fallback() {
    echo "Previewer cannot generate a preview based on its extension or mimetype."
    echo "File Path: ${FILE_PATH}"
    echo "File Extension: ${FILE_EXT}"
    echo "Mime Type: ${MIMETYPE}"
    exit 1
}

handle_missing_viewer() {
    echo "Previewer cannot find a viewer that can process this filetype."
    echo "File Path: ${FILE_PATH}"
    echo "File Extension: ${FILE_EXT}"
    echo "Mime Type: ${MIMETYPE}"
    echo "Expected previewer: ${1:-Unknown}"
    exit 2
}

examine_file_path "${1}"
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback "${MIMETYPE}"
