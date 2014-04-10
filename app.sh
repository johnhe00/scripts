#!/bin/bash

function app_check {
    app_name=$1
    if `screen -ls | grep -q $app_name`; then
        printf 'started'
    else
        printf 'stopped'
    fi
}

function app_open {
    app_name=$1
    local status=$(app_check $app_name)
    if [ $status == 'started' ]; then
        screen -r $app_name
    else
        printf "$app_name is not running\n"
    fi
}

function app_stop {
    app_name=$1
  if `screen -ls | grep -q $app_name`; then
    printf "stopping $app_name\n"
    screen -S $app_name -X quit
  else
    printf "$app_name is not currently running\n"
  fi
}

function app_start {
    app_name=$1
    shift
  if `screen -ls | grep -q $app_name`; then
    printf "$app_name is already running\n"
  else
    printf "starting $app_name\n"
    screen -d -m -S $app_name "$@"
  fi
}

