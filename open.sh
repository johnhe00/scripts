#!/bin/bash

function main() {
  if [[ -d "$@" ]]; then
    nautilus "$@"
    exit 0
  fi

  local ext="${@##*.}"
  ext=$(printf "$ext" | tr '[:upper:]' '[:lower:]')

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
    mkv|mid|midi|mp4|mp3|avi|mid|midi|flac|ogg|ogv|wav)
      nohup vlc "$@" >/dev/null 2>&1 &
      ;;
    txt|py|c|cpp|cc|log|out|java|ly)
      nohup gedit "$@" >/dev/null 2>&1 &
      ;;
    zip|rar|tar|jar|gz|tgz|bz2)
      nohup file-roller "$@" >/dev/null 2>&1 &
      ;;
    *)
      printf "unknown file type: $ext\n"
      exit 1
      ;;
    esac
}

main "$@"
