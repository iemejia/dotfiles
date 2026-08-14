#!/usr/bin/env bash
#
# joincmd.sh
#
# Join a multi-line command (using backslash continuations) into a single line.
# The reverse of splitcmd.sh.
#
# Usage:
#   joincmd.sh '<multi-line command>'
#   echo '<multi-line command>' | joincmd.sh
#   joincmd.sh < file.txt
#
# Examples:
#   printf 'llama-cli \\\n    --model coco \\\n    --threads 8' | joincmd.sh
#
#   Output:
#     llama-cli --model coco --threads 8
#

set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") '<command>'"
  echo "       echo '<command>' | $(basename "$0")"
  echo "       $(basename "$0") < file.txt"
  exit 1
}

joincmd() {
  # Remove trailing backslashes, join lines, and collapse whitespace
  sed 's/\\$//' | tr '\n' ' ' | sed 's/  */ /g; s/^ //; s/ $//'
}

if [[ $# -gt 0 ]]; then
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
  fi
  printf '%s\n' "$@" | joincmd
elif [[ ! -t 0 ]]; then
  joincmd
else
  usage
fi
