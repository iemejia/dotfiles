#!/usr/bin/env bash
#
# splitcmd.sh
#
# Format a single-line CLI command into a multi-line form using backslash
# continuations, splitting on flag boundaries (--flag and -f).
#
# Usage:
#   splitcmd.sh <command>
#   echo '<command>' | splitcmd.sh
#
# Examples:
#   splitcmd.sh 'llama-cli --model coco --threads 8 --ctx-size 4096'
#
#   Output:
#     llama-cli \
#         --model coco \
#         --threads 8 \
#         --ctx-size 4096
#

set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") '<command>'"
  echo "       echo '<command>' | $(basename "$0")"
  exit 1
}

splitcmd() {
  local input="$1"

  # Split on long flags (--) and short flags (-x), preserving the flag
  echo "$input" \
    | sed 's/ --/ \\\n    --/g' \
    | sed 's/ -\([^-]\)/ \\\n    -\1/g'
}

if [[ $# -gt 0 ]]; then
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
  fi
  splitcmd "$*"
elif [[ ! -t 0 ]]; then
  while IFS= read -r line; do
    splitcmd "$line"
  done
else
  usage
fi
