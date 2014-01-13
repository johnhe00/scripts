#!/bin/bash

function main() {
    if `echo $@ | grep -q '\.n64$'`; then
        mupen64plus $@
    elif `echo $@ | grep -q '\.gba$'`; then
        mednafen $@
    elif `echo $@ | grep -q '\.pdf$'`; then
        evince $@
    else
        echo "Unrecognized file: $@"
        exit 1
    fi
}

main $@
