#!/bin/bash

readonly SERVER="glacier"
readonly PORT="12345"
readonly APP_NAME="ssh-$SERVER-tunnel"
readonly CMD="ssh -C -D $PORT $SERVER"

source /home/johnhe00/scripts/app.sh
main "$@"
