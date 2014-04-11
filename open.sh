#!/bin/bash

function main() {
  if [ -d "$@" ]; then
    nautilus "$@"
    exit 0
  fi
  local ext="${@##*.}"
  ext=$(printf $ext | tr 'A-Z' 'a-z')

  # nohup cmd "$@" >/dev/null 2>&1 &
  case $ext in
    n64)
      nohup mupen64plus "$@" >/dev/null 2>&1 &
      ;;
    gba)
      nohup mednafen "$@" >/dev/null 2>&1 &
      ;;
    pdf)
      nohup evince "$@" >/dev/null 2>&1 &
      ;;
    mkv|mid|midi|mp4|mp3|avi)
      nohup vlc "$@" >/dev/null 2>&1 &
      ;;
    txt|py|c|cpp|cc|log|out|java)
      nohup gedit "$@" >/dev/null 2>&1 &
      ;;
    *)
      printf "unknown file type: $ext\n"
      exit 1
      ;;
    esac
}

main "$@"
