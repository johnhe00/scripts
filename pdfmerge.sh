#!/bin/bash

usage() {
cat << EOF
usage: pdfmerge <inputs> <output>
EOF
}

main() {
  # Last parameter
  local output=${!#}
  # Everything else
  local inputs=${@:1:$(($#-1))}

  if [[ -z "$inputs" ]]; then
    usage
    exit 1
  elif [[ -z "$output" ]]; then
    usage
    exit 1
  fi

  pdftk "${@:1:$(($#-1))}" cat output "$output"
}

main "$@"
