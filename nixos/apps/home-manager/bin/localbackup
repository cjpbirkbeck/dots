#!/usr/bin/env bash
# If the drives with those names are present, back home directory
# with rsync and borgbackup, respectively.

double_backup() {
    if test -e /run/media/cjpbirkbeck/"${1}"/; then
        cd /run/media/cjpbirkbeck/"${1}"/ || exit 1

        mkdir -p "$(uname -n)"/{rsync,borg} && cd "$(uname -n)" || exit 2

        cd ./rsync || exit 3
        rsync -azv --delete "$HOME" .

        cd ../borg || exit 3
        borg create --progress --stats .::"$(date '+%F')" ~
    fi
}

double_backup "Linux-Archive-HD"
double_backup "Backup 1"
