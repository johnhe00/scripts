#!/bin/bash

app_check() {
  if $(screen -ls | grep -q "$APP_NAME"); then
    return 1
  else
    return 0
  fi
}

app_open() {
  app_check
  if [ $? -eq 1 ]; then
    screen -r "$APP_NAME"
  else
    printf "$APP_NAME is not running\n"
  fi
}

app_stop() {
  app_check
  if [ $? -eq 1 ]; then
    printf "stopping $APP_NAME\n"
    screen -S "$APP_NAME" -X quit
  else
    printf "$APP_NAME is not running\n"
  fi
}

app_start() {
  app_check
  if [ $? -eq 1 ]; then
    printf "$APP_NAME is already running\n"
  else
    printf "starting $APP_NAME\n"
    screen -d -m -S "$APP_NAME" $CMD
  fi
}

app_status() {
  app_check
  if [ $? -eq 1 ]; then
    printf "started\n"
  else
    printf "stopped\n"
  fi
}

main() {
  local param=$1
  case $param in
    start)
      app_start
    ;;
    status)
      app_status
    ;;
    open)
      app_open
    ;;
    stop)
      app_stop
    ;;
    restart)
      app_stop
      sleep 1
      app_start
    ;;
    *)
    ;;
  esac
}

