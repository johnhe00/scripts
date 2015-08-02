#!/bin/bash

readonly APP_NAME="ssh-proxy"
readonly CMD="ssh -D 12345 glacier"

source /home/johnhe00/scripts/app.sh
main "$@"
