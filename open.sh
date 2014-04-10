#!/bin/bash

function main() {
    if `echo "$@" | grep -qi '\.n64$'`; then
        mupen64plus "$@"
    elif `echo "$@" | grep -qi '\.gba$'`; then
        mednafen "$@"
    elif `echo $@ | grep -qi '\.pdf$'`; then
        evince "$@" &
    elif `echo $@ | grep -qi '\.mkv$'`; then
        vlc "$@" &
    else
        echo "Unrecognized file: $@"
        exit 1
    fi
}

main "$@"
