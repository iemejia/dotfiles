#!/usr/bin/env bash
#
# git-amend-commits.sh
#
# Amend git commits to add an "Assisted-by" trailer and optionally change the
# author. Follows the Linux kernel convention documented in
# Documentation/process/coding-assistants.rst:
#
#   Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]
#
# This script rewrites commit messages using interactive rebase and
# `git interpret-trailers` to append the trailer cleanly.
#
# Usage:
#   git-amend-commits.sh [options] [<commit>...]
#   git-amend-commits.sh [options] [--range <base>..<tip>]
#   git-amend-commits.sh --help
#
#   With no arguments, applies defaults to the last commit (HEAD~1..HEAD).
#
# Examples:
#   # Add trailer to the last 3 commits
#   git-amend-commits.sh --range HEAD~3..HEAD
#
#   # Add trailer to specific commits
#   git-amend-commits.sh abc1234 def5678
#
#   # Custom assisted-by value
#   git-amend-commits.sh --tag "Claude:claude-3-opus coccinelle sparse" HEAD~2..HEAD
#
#   # Dry-run: show what would be changed without rewriting
#   git-amend-commits.sh --dry-run --range HEAD~5..HEAD
#

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Constants
# ─────────────────────────────────────────────────────────────────────────────
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"
DEFAULT_AGENT="GitHub Copilot"
DEFAULT_MODEL="claude-opus-4.6"
DEFAULT_RANGE="HEAD~1..HEAD"

# Build default author from git config (graceful if not set)
_git_name="$(git config user.name 2>/dev/null || true)"
_git_email="$(git config user.email 2>/dev/null || true)"
if [[ -n "$_git_name" && -n "$_git_email" ]]; then
  DEFAULT_AUTHOR="${_git_name} <${_git_email}>"
elif [[ -n "$_git_name" ]]; then
  DEFAULT_AUTHOR="$_git_name"
else
  DEFAULT_AUTHOR=""
fi
unset _git_name _git_email

# ─────────────────────────────────────────────────────────────────────────────
# Color helpers
# ─────────────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; }

# ─────────────────────────────────────────────────────────────────────────────
# Utility functions
# ─────────────────────────────────────────────────────────────────────────────

check_prerequisites() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    error "Not inside a git repository."
    exit 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    error "Working tree is not clean. Commit or stash your changes first."
    exit 1
  fi
}

# Check if a commit message already contains an Assisted-by trailer
has_assisted_by() {
  local hash="$1"
  git log -1 --format='%B' "$hash" | grep -q '^Assisted-by:' 2>/dev/null
}

# ─────────────────────────────────────────────────────────────────────────────
# Core: add trailer to commits in a range
# ─────────────────────────────────────────────────────────────────────────────

add_trailer_range() {
  local base="$1"
  local trailer_value="$2"
  local dry_run="$3"
  local skip_existing="$4"
  local author="$5"

  # Resolve the commits in the range
  local commits=()
  while IFS= read -r hash; do
    [[ -z "$hash" ]] && continue
    commits+=("$hash")
  done < <(git rev-list --reverse "$base")

  local total=${#commits[@]}
  if [[ $total -eq 0 ]]; then
    warn "No commits found in range: $base"
    return 0
  fi

  info "Found $total commit(s) in range"

  if [[ "$dry_run" == "true" ]]; then
    echo ""
    info "Dry-run: showing commits that would be modified"
    echo ""
    for hash in "${commits[@]}"; do
      local short subject
      short=$(git rev-parse --short "$hash")
      subject=$(git log -1 --format='%s' "$hash")
      if [[ "$skip_existing" == "true" ]] && has_assisted_by "$hash"; then
        warn "SKIP (already has trailer): $short $subject"
      else
        success "WOULD ADD: $short $subject"
        echo "    Assisted-by: $trailer_value"
        [[ -n "$author" ]] && echo "    Author: $author"
      fi
    done
    return 0
  fi

  # Find the base commit (parent of the oldest commit in range)
  local rebase_base
  rebase_base=$(git rev-list --reverse "$base" | head -1)
  rebase_base=$(git rev-parse "${rebase_base}^" 2>/dev/null) || {
    # If there's no parent (root commit), use --root
    rebase_base="--root"
  }

  # Build the exec command for rebase
  # The exec command checks for existing trailer and adds if missing
  local amend_flags=""
  [[ -n "$author" ]] && amend_flags="--author='${author}'"

  local exec_cmd
  if [[ "$skip_existing" == "true" ]]; then
    exec_cmd="if ! git log -1 --format='%B' | grep -q '^Assisted-by:'; then git log -1 --format='%B' | git interpret-trailers --trailer 'Assisted-by: ${trailer_value}' | git commit --amend ${amend_flags} -F -; fi"
  else
    exec_cmd="git log -1 --format='%B' | git interpret-trailers --trailer 'Assisted-by: ${trailer_value}' | git commit --amend ${amend_flags} -F -"
  fi

  info "Rebasing to add trailer..."
  info "  Assisted-by: $trailer_value"
  [[ -n "$author" ]] && info "  Author: $author"
  echo ""

  if [[ "$rebase_base" == "--root" ]]; then
    GIT_SEQUENCE_EDITOR=: git rebase --root --exec "$exec_cmd"
  else
    GIT_SEQUENCE_EDITOR=: git rebase "$rebase_base" --exec "$exec_cmd"
  fi

  echo ""
  success "Added Assisted-by trailer to $total commit(s)"
}

# ─────────────────────────────────────────────────────────────────────────────
# Core: add trailer to specific commits
# ─────────────────────────────────────────────────────────────────────────────

add_trailer_commits() {
  local trailer_value="$1"
  local dry_run="$2"
  local skip_existing="$3"
  local author="$4"
  shift 4
  local commits=("$@")

  local total=${#commits[@]}
  info "Processing $total specific commit(s)"

  # Resolve all hashes to full form and validate
  local resolved=()
  for ref in "${commits[@]}"; do
    local full_hash
    full_hash=$(git rev-parse "$ref" 2>/dev/null) || {
      error "Cannot resolve commit: $ref"
      exit 1
    }
    resolved+=("$full_hash")
  done

  if [[ "$dry_run" == "true" ]]; then
    echo ""
    info "Dry-run: showing commits that would be modified"
    echo ""
    for hash in "${resolved[@]}"; do
      local short subject
      short=$(git rev-parse --short "$hash")
      subject=$(git log -1 --format='%s' "$hash")
      if [[ "$skip_existing" == "true" ]] && has_assisted_by "$hash"; then
        warn "SKIP (already has trailer): $short $subject"
      else
        success "WOULD ADD: $short $subject"
        echo "    Assisted-by: $trailer_value"
        [[ -n "$author" ]] && echo "    Author: $author"
      fi
    done
    return 0
  fi

  # Find the oldest commit to determine rebase base
  local oldest_hash
  oldest_hash=$(git rev-list --reverse HEAD -- | while IFS= read -r h; do
    for target in "${resolved[@]}"; do
      if [[ "$h" == "$target" ]]; then
        echo "$h"
        break 2
      fi
    done
  done)

  if [[ -z "$oldest_hash" ]]; then
    error "None of the specified commits are ancestors of HEAD"
    exit 1
  fi

  local rebase_base
  rebase_base=$(git rev-parse "${oldest_hash}^" 2>/dev/null) || rebase_base="--root"

  # Create a temporary file with the hashes to modify
  local tmp_hashes
  tmp_hashes=$(mktemp)
  trap 'rm -f "$tmp_hashes"' EXIT
  printf '%s\n' "${resolved[@]}" > "$tmp_hashes"

  # Build exec command that only modifies commits in our list
  local amend_flags=""
  [[ -n "$author" ]] && amend_flags="--author='${author}'"

  local exec_cmd
  if [[ "$skip_existing" == "true" ]]; then
    exec_cmd="if grep -q \$(git rev-parse HEAD) '$tmp_hashes' 2>/dev/null && ! git log -1 --format='%B' | grep -q '^Assisted-by:'; then git log -1 --format='%B' | git interpret-trailers --trailer 'Assisted-by: ${trailer_value}' | git commit --amend ${amend_flags} -F -; fi"
  else
    exec_cmd="if grep -q \$(git rev-parse HEAD) '$tmp_hashes' 2>/dev/null; then git log -1 --format='%B' | git interpret-trailers --trailer 'Assisted-by: ${trailer_value}' | git commit --amend ${amend_flags} -F -; fi"
  fi

  info "Rebasing to add trailer to selected commits..."
  info "  Assisted-by: $trailer_value"
  [[ -n "$author" ]] && info "  Author: $author"
  echo ""

  if [[ "$rebase_base" == "--root" ]]; then
    GIT_SEQUENCE_EDITOR=: git rebase --root --exec "$exec_cmd"
  else
    GIT_SEQUENCE_EDITOR=: git rebase "$rebase_base" --exec "$exec_cmd"
  fi

  echo ""
  success "Added Assisted-by trailer to selected commit(s)"
}

# ─────────────────────────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────────────────────────

do_help() {
  cat <<HELP
${BOLD}$SCRIPT_NAME${NC} v$VERSION - Add Assisted-by trailers to git commits

Follows the Linux kernel convention from
Documentation/process/coding-assistants.rst:
  Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]

${BOLD}USAGE:${NC}
  $SCRIPT_NAME [options] [--range <base>..<tip>]
  $SCRIPT_NAME [options] [<commit>...]
  $SCRIPT_NAME --help

  When called with no arguments or no commits/range, defaults to the
  last commit (${DEFAULT_RANGE}) using all default values.

${BOLD}OPTIONS:${NC}
  ${BOLD}--tag <value>${NC}
      Full trailer value. Overrides --agent and --model.
      Example: --tag "Claude:claude-3-opus coccinelle sparse"

  ${BOLD}--agent <name>${NC}
      Agent name (default: $DEFAULT_AGENT)

  ${BOLD}--model <version>${NC}
      Model version (default: $DEFAULT_MODEL)

  ${BOLD}--tools <tool1> [tool2] ...${NC}
      Optional tools to append (e.g., coccinelle sparse).
      Must be the last option (consumes remaining args until --)

  ${BOLD}--author <"Name <email>">${NC}
      Override the commit author for rewritten commits.
      Uses standard git format: "Name <email>"
      Default: from git config (currently: $DEFAULT_AUTHOR)
      Example: --author "Jane Doe <jane@example.com>"

  ${BOLD}--range <base>..<tip>${NC}
      Apply to all commits in the given range.
      Examples: HEAD~5..HEAD, main..feature, abc123..HEAD

  ${BOLD}--skip-existing${NC}
      Skip commits that already have an Assisted-by trailer (default).

  ${BOLD}--no-skip-existing${NC}
      Add trailer even if one already exists (creates duplicate).

  ${BOLD}--dry-run${NC}
      Show what would be changed without actually rewriting history.

  ${BOLD}--help, -h${NC}
      Show this help message.

${BOLD}EXAMPLES:${NC}
  # No arguments: add trailer to last commit with all defaults
  $SCRIPT_NAME

  # Add trailer to the last 3 commits (uses defaults)
  $SCRIPT_NAME --range HEAD~3..HEAD

  # Custom agent and model
  $SCRIPT_NAME --agent "Copilot" --model "gpt-4" --range HEAD~2..HEAD

  # Full custom tag with tools
  $SCRIPT_NAME --tag "Claude:claude-3-opus coccinelle sparse" --range HEAD~5..HEAD

  # Change commit author while adding trailer
  $SCRIPT_NAME --author "Jane Doe <jane@example.com>" --range HEAD~3..HEAD

  # Specific commits only
  $SCRIPT_NAME abc1234 def5678 ghi9012

  # Dry-run first
  $SCRIPT_NAME --dry-run --range HEAD~10..HEAD

${BOLD}NOTES:${NC}
  - This rewrites git history. Do NOT use on commits already pushed to
    a shared branch without coordinating with collaborators.
  - Working tree must be clean (no uncommitted changes).
  - The trailer is appended using \`git interpret-trailers\`, which ensures
    proper formatting with a blank line before the trailer block.
  - By default, commits that already have an Assisted-by trailer are skipped.
HELP
}

# ─────────────────────────────────────────────────────────────────────────────
# Argument parsing
# ─────────────────────────────────────────────────────────────────────────────

main() {
  local agent="$DEFAULT_AGENT"
  local model="$DEFAULT_MODEL"
  local tag=""
  local tools=()
  local range=""
  local dry_run="false"
  local skip_existing="true"
  local author="$DEFAULT_AUTHOR"
  local commits=()

  if [[ $# -eq 0 ]]; then
    # No arguments: use defaults (last commit)
    info "No arguments provided, defaulting to last commit (${DEFAULT_RANGE})"
    range="$DEFAULT_RANGE"
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        do_help
        exit 0
        ;;
      --version|-v)
        echo "$SCRIPT_NAME v$VERSION"
        exit 0
        ;;
      --tag)
        if [[ $# -lt 2 ]]; then
          error "--tag requires a value"
          exit 1
        fi
        tag="$2"
        shift 2
        ;;
      --agent)
        if [[ $# -lt 2 ]]; then
          error "--agent requires a value"
          exit 1
        fi
        agent="$2"
        shift 2
        ;;
      --model)
        if [[ $# -lt 2 ]]; then
          error "--model requires a value"
          exit 1
        fi
        model="$2"
        shift 2
        ;;
      --tools)
        shift
        while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
          tools+=("$1")
          shift
        done
        ;;
      --author)
        if [[ $# -lt 2 ]]; then
          error "--author requires a value (e.g., \"Name <email>\")"
          exit 1
        fi
        author="$2"
        shift 2
        ;;
      --range)
        if [[ $# -lt 2 ]]; then
          error "--range requires a value (e.g., HEAD~3..HEAD)"
          exit 1
        fi
        range="$2"
        shift 2
        ;;
      --dry-run)
        dry_run="true"
        shift
        ;;
      --skip-existing)
        skip_existing="true"
        shift
        ;;
      --no-skip-existing)
        skip_existing="false"
        shift
        ;;
      -*)
        error "Unknown option: $1"
        exit 1
        ;;
      *)
        # Treat as commit reference
        commits+=("$1")
        shift
        ;;
    esac
  done

  # Build the trailer value
  local trailer_value
  if [[ -n "$tag" ]]; then
    trailer_value="$tag"
  else
    trailer_value="${agent}:${model}"
    if [[ ${#tools[@]} -gt 0 ]]; then
      trailer_value="$trailer_value ${tools[*]}"
    fi
  fi

  # If no range or commits specified, default to last commit
  if [[ -z "$range" && ${#commits[@]} -eq 0 ]]; then
    info "No commits specified, defaulting to last commit (${DEFAULT_RANGE})"
    range="$DEFAULT_RANGE"
  fi

  check_prerequisites

  info "Trailer: Assisted-by: $trailer_value"
  [[ -n "$author" ]] && info "Author:  $author"
  echo ""

  if [[ -n "$range" ]]; then
    add_trailer_range "$range" "$trailer_value" "$dry_run" "$skip_existing" "$author"
  else
    add_trailer_commits "$trailer_value" "$dry_run" "$skip_existing" "$author" "${commits[@]}"
  fi
}

main "$@"
