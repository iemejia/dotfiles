#!/usr/bin/env bash

usage() {
  cat <<EOF
Usage: $(basename "$0") [NAME] [COLUMNS] [ROWS]

Create a tmux grid of COLUMNS x ROWS panes.
If run inside tmux, a new window is created in the current session.
Otherwise a new detached session is created and attached.

Arguments:
  NAME      Session/window name      (default: agents)
  COLUMNS   Number of columns        (default: 4)
  ROWS      Number of rows           (default: 1)

Options:
  -h, --help   Show this help message and exit

Examples:
  $(basename "$0")                  # session 'agents' with 4 columns, 1 row
  $(basename "$0") work 3 2         # session 'work' as a 3x2 grid
  $(basename "$0") dev 2 3          # session 'dev'  as a 2x3 grid
EOF
}

case "$1" in
  -h|--help)
    usage
    exit 0
    ;;
esac

SESSION_NAME=${1:-agents}
NUM_COLS=${2:-4}
NUM_ROWS=${3:-1}

# Build a grid of NUM_COLS columns x NUM_ROWS rows.
build_grid() {
  local target="$1"
  local cols=$NUM_COLS
  local rows=$NUM_ROWS

  # Step 1: create columns by horizontally splitting.
  local column_panes=()
  local first_pane
  first_pane=$(tmux list-panes -t "$target" -F '#{pane_id}' | head -n1)
  column_panes+=("$first_pane")

  for ((i=1; i<cols; i++)); do
    local new_pane
    new_pane=$(tmux split-window -h -t "$target" -P -F '#{pane_id}')
    column_panes+=("$new_pane")
  done

  # Equalize column widths.
  tmux select-layout -t "$target" even-horizontal

  # Step 2: split each column vertically with calculated percentages so rows are equal.
  for pane in "${column_panes[@]}"; do
    local current="$pane"
    for ((j=1; j<rows; j++)); do
      local remaining=$((rows - j + 1))
      local pct=$((100 - 100 / remaining))
      current=$(tmux split-window -v -l "${pct}%" -t "$current" -P -F '#{pane_id}')
    done
  done
}

if [ -n "$TMUX" ]; then
  tmux new-window -n "$SESSION_NAME"
  TARGET=$(tmux display-message -p '#{session_name}:#{window_index}')
  build_grid "$TARGET"
else
  tmux new-session -d -s "$SESSION_NAME"
  build_grid "$SESSION_NAME"
  tmux attach -t "$SESSION_NAME"
fi
