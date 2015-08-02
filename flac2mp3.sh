#!/bin/bash

main() {
  for f in "$@"; do
    flac -cd "$f" | lame -b 320 - "${f%.*}".mp3 ;
  done
}

main "$@"
