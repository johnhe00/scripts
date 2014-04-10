#!/bin/bash

function usage {
    echo ""
}

function error {
  printf "$@" 1>&2
}

function params {
    printf "Help\n"
}

function prune {
    for file in "$@"
    do
        find "$file" -type f -not -iname "*.mp3" -exec rm -i {} \;
    done

    for file in "$@"
    do
        find "$file" -empty -exec rm -ri {} \;
    done
}

function sync {
    local DRY="rsync -himnrtW"
    local WET="rsync -hmrtW --delete-delay --progress"
    for file in "$@"
    do
        local escaped=$(printf "$file" | sed 's/ /\\ /g')
        DRY="$DRY $escaped"
        WET="$WET $escaped"
    done

    eval "$DRY"

    read -p "Execute? [y/n] " response
    case $response in
        [Yy])
            eval "$WET"
        ;;
        *)
            printf "Aborting ...\n"
        ;;
    esac
}

function unicode {
    for file in "$@"
    do
        if [ ! -e "$file" ]; then
            error "$file does not exist\n"
            continue
        fi
        find "$file" | grep --color -P "[^[:ascii:]]"
    done
}

function main {
    if [ $# -lt 1 ]; then
        error "$(usage)"
        exit 1
    fi

    local COMMAND=$1
    shift

    case $COMMAND in
        help)
            params
        ;;
        prune)
            prune "$@"
        ;;
        sync)
            sync "$@"
        ;;
        unicode)
            unicode "$@"
        ;;
        *)
            printf "Unrecognized Command\n"
        ;;
    esac
}

main "$@"
