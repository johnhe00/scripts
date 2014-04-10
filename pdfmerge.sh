#!/bin/bash

function usage {
  printf "Usage: pdfmerge <inputs *> <output>\n"
}

function error {
  printf "$@" 1>&2
  exit 1
}

function build {
  if [ $# -lt 2 ]; then
    error "$(usage)"
  fi

  local command="pdftk"
  local output="${!#}"
  local files="${@:1:$(($#-1))}"

  for file in $files; do
    local escaped=$(printf $file | sed 's/ /\\ /g')
    if [ ! -f "$escaped" ]; then
      error "$file: no such file or directory"
    fi
    command="$command $escaped"
  done
  printf "$command cat output $output"
  return 0
}

function main {
  IFS=$'\n'
  local command="$(build $@)"
  $command
}

main $@
