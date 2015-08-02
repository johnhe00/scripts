#!/bin/bash

usage() {
cat << EOF
usage: music <command> <dirs>

commands:
    filename
        music filename <dir>
        Check for illegal file/path characters for Windows.
    mount
        music mount <dir>
        Mounts a directory to ~/Music/
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

filename() {
  for file in "$@"; do
    find "$file" | grep -E --color "\"|<|>|:|\\|\||\?|\*"
  done
}

mount() {
  local MUSIC=/home/johnhe00/Music

  if [ -L "$MUSIC" ]; then
    read -p "Link already exists. Replace? [yes/N] " response
    case $response in
    yes)
      rm -i "$MUSIC"
    ;;
    *)
    ;;
    esac
  fi

  if [ ! -e "$MUSIC" ]; then
    if [ -d "$@" ]; then
      ln -s "$@" "$MUSIC"
    else
      printf "$@ doesn't exist"
    fi
  fi
}

prune() {
  for file in "$@"; do
    find "$file" -type f -not -iname "*.mp3"
  done

  read -p "Delete? [yes/N] " response
  case $response in
    yes)
      for file in "$@"; do
        find "$file" -type f -not -iname "*.mp3" -exec rm {} \;
      done

      sleep 1

      for file in "$@"; do
        find "$file" -empty -exec rmdir {} \;
      done
    ;;
    *)
      printf "Aborting ...\n"
    ;;
  esac
}

sync() {
  local DRY="rsync -himnrt"
  local WET="rsync -hmrtW --delete-delay --progress"

  $DRY "$@"

  read -p "Execute? [yes/N] " response
  case $response in
    yes)
      $WET "$@"
      ;;
    *)
      printf "Aborting ...\n"
      ;;
  esac
}

unicode() {
  for file in "$@"; do
    find "$file" | grep --color -P "[^[:ascii:]]"
  done
}

main() {
  if [[ $# -lt 1 ]]; then
    usage
    exit 1
  fi

  local COMMAND=$1
  shift

  case $COMMAND in
    filename)
      filename "$@"
      ;;
    mount)
      mount "$@"
      ;;
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
