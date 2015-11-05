#!/bin/bash

LAME_FLAGS="-b 320"

usage() {
cat << EOF
usage: music <command> <dirs>

commands:
    filename
        music filename <dir>
        Check for illegal file/path characters for Windows
    mount
        music mount <dir>
        Mounts a directory to ~/Music/
    mpv0
        music mpv0 <filename> [<filenames>]
        Converts the files to vbr0 mp3
    mp320
        music mp320 <filename> [<filenames>]
        Converts the files to cbr320 mp3
    prune
        music prune <dir1> [<dirs>]
        Remove non-mp3 and empty files and directories
    sync
        music sync <src1> [<srcs>] <dst>
        'rsync -hmrtW --delete-delay --progress'
    unicode
        music unicode <dir1> [<dirs>]
        Find filenames with unicode characters
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
      printf "$@ doesn't exist\n"
    fi
  fi
}

mpv0() {
  LAME_FLAGS="-V 0"
  mp3 "$@"
}

mp3() {
  for file in "$@"; do
    if [[ -d "$file" ]]; then
      printf "$file is a directory\n"
      continue
    fi

    newfile="${file%.*}.mp3"
    if [[ -e $newfile ]]; then
      printf "$newfile already exists\n"
      continue
    fi

    mime=$(file --mime-type -b "$file")
    case $mime in
      audio/x-flac)
        flac -cds "$file" | lame $LAME_FLAGS - "$newfile"
        ;;
      audio/x-wav)
        lame $LAME_FLAGS "$file" "$newfile"
        ;;
      *)
        printf "$file has an incompatible mime: $mime\n"
        ;;
    esac
  done
}

mp320() {
  LAME_FLAGS="-b 320"
  mp3 "$@"
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
    mpv0)
      mpv0 "$@"
      ;;
    mp320)
      mp320 "$@"
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
