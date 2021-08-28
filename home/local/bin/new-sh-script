#!/usr/bin/env dash

test -z "$1" && printf "No new file found.\n" >&2 && exit 1

# If there is no given filetype, assume it is just a plain POSIX script.
test -z "$NEWFILETYPE" && NEWFILETYPE="sh"

# POSIX shell doesn't use the env binary.
# scripts for the dash interpeted should use the sh extension.
if test "$NEWFILETYPE" = "sh"; then
    FILE_EXT="$NEWFILETYPE"
    HASHBANG="#!/bin/sh"
elif test "$NEWFILETYPE" = "dash"; then
    FILE_EXT="sh"
    HASHBANG="#!/usr/bin/env ${NEWFILETYPE}"
else
    FILE_EXT="$NEWFILETYPE"
    HASHBANG="#!/usr/bin/env ${NEWFILETYPE}"
fi

newfile="$1.${FILE_EXT}"

test -e "$newfile" && printf "File already exits, exiting.\n" && exit 2

if ! touch "$newfile"; then
    printf "Cannot create file, exiting.\n"
    exit 3
fi

echo "${HASHBANG}\n# TODO: Write a brief description of this script.\n\n" >> "${newfile}"
chmod u+x "$newfile"
