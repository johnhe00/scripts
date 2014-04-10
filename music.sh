#!/bin/bash

function error {
  printf "$@" 1>&2
}

function usage {
cat << EOF
usage: music <command> <dirs>

commands:
    prune
        music prune <dir1> [<dirs>]
        Remove non-mp3 and empty files and folders in the given directories.
    sync
        music sync <src1> [<srcs>] <dst>
        'rsync -hmrtW --delete-delay --progress' for the given sources and destination.
    unicode
        music unicode <dir1> [<dirs>]
        Find filenames with unicode characters in the given directories.
EOF
}

function prune {
  for file in "$@"; do
    find "$file" -type f -not -iname "*.mp3" -exec rm -i {} \;
  done

  for file in "$@"; do
    find "$file" -empty -exec rm -ri {} \;
  done
}

function sync {
  local DRY="rsync -himnrtW"
  local WET="rsync -hmrtW --delete-delay --progress"
  for file in "$@"; do
    local escaped=$(printf "$file" | sed 's/ /\\ /g')
    DRY="$DRY $escaped"
    WET="$WET $escaped"
  done

  $DRY

  read -p "Execute? [y/n] " response
  case $response in
    [Yy])
      $WET
      ;;
    *)
      printf "Aborting ...\n"
      ;;
  esac
}

function unicode {
  for file in "$@"; do
    if [ ! -e "$file" ]; then
      error "$file does not exist\n"
      continue
    fi
    find "$file" | grep --color -P "[^[:ascii:]]"
  done
}

function main {
  if [ $# -lt 1 ]; then
    usage
    exit 1
  fi

  local COMMAND=$1
  shift

  case $COMMAND in
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
      printf "unrecognized command: $COMMAND\n"
      usage
      ;;
  esac
}

main "$@"
