#!/usr/bin/env bash
#
# git-cherry-picker.sh
#
# Generic tool for discovering and applying cherry-picks between any two
# branches in a git repository.
#
# This script has three modes:
#   --list      Export the full list of commits on <source-branch> that are
#               not yet on <target-branch> (by patch-id).  Fast, no
#               cherry-pick testing.  Useful as a quick inventory step.
#   --analyze   Discover which commits from <source-branch> can be cleanly
#               cherry-picked into <target-branch>.  Uses cumulative testing
#               (oldest first, keeping successful picks so later commits
#               benefit from earlier ones).  Produces output files listing
#               clean and conflicting commits.
#   --execute   Apply cherry-picks from a previously generated list file.
#
# Prerequisites:
#   - Inside a git repository
#   - Both source and target branches must exist locally
#   - Clean working tree (no uncommitted changes)
#
# Usage:
#   git-cherry-picker.sh --list    <source-branch> <target-branch> [--exclude <file>]
#   git-cherry-picker.sh --analyze <source-branch> <target-branch> [--exclude <file>]
#   git-cherry-picker.sh --execute <target-branch> <list-file>
#   git-cherry-picker.sh --help
#
# Examples:
#   # Quick inventory: list all commits on main not yet in release-2.0
#   ./git-cherry-picker.sh --list main release-2.0
#
#   # Find what can be cherry-picked from main into release-2.0
#   ./git-cherry-picker.sh --analyze main release-2.0
#
#   # Same, but skip commits listed in exclusions.txt
#   ./git-cherry-picker.sh --analyze main release-2.0 --exclude exclusions.txt
#
#   # Apply cherry-picks from a previous --analyze run
#   ./git-cherry-picker.sh --execute release-2.0 cherry-pick-release-2.0-clean.txt
#

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Constants
# ─────────────────────────────────────────────────────────────────────────────
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"

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

# Verify we're in a git repo, branches exist, and working tree is clean.
check_prerequisites() {
  local source_branch="$1"
  local target_branch="$2"

  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    error "Not inside a git repository."
    exit 1
  fi

  if ! git rev-parse --verify "$source_branch" &>/dev/null; then
    error "Branch '$source_branch' not found. Fetch it first:"
    error "  git fetch origin $source_branch:$source_branch"
    exit 1
  fi

  if ! git rev-parse --verify "$target_branch" &>/dev/null; then
    error "Branch '$target_branch' not found. Fetch it first:"
    error "  git fetch origin $target_branch:$target_branch"
    exit 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    error "Working tree is not clean. Commit or stash your changes first."
    exit 1
  fi
}

# Load exclusions from an external file (one hash per line, # comments).
# Populates the global EXCLUDED_COMMITS array.
load_exclusions() {
  local exclude_file="$1"
  EXCLUDED_COMMITS=()

  if [[ ! -f "$exclude_file" ]]; then
    error "Exclusion file not found: $exclude_file"
    exit 1
  fi

  while IFS= read -r line; do
    # Strip inline comments and leading/trailing whitespace
    line="${line%%#*}"
    line="${line// /}"
    line="$(echo "$line" | xargs 2>/dev/null || true)"
    if [[ -n "$line" ]]; then
      EXCLUDED_COMMITS+=("$line")
    fi
  done < "$exclude_file"

  info "Loaded ${#EXCLUDED_COMMITS[@]} exclusions from $exclude_file"
}

# Check if a commit hash matches any entry in EXCLUDED_COMMITS.
is_excluded() {
  local hash="$1"
  local full_hash
  full_hash=$(git rev-parse "$hash" 2>/dev/null) || return 1

  for excluded in "${EXCLUDED_COMMITS[@]}"; do
    # Resolve the excluded hash to full form too (handles short hashes)
    local excluded_full
    excluded_full=$(git rev-parse "$excluded" 2>/dev/null) || continue
    if [[ "$full_hash" == "$excluded_full" ]]; then
      return 0
    fi
  done
  return 1
}

# Sanitize a branch name for use in filenames (replace / with -)
branch_to_filename() {
  echo "$1" | sed 's|/|-|g'
}

# ─────────────────────────────────────────────────────────────────────────────
# Mode: --list
# Export the full list of commits on source that are not yet on target
# (by patch-id).  No cherry-pick testing — just a fast inventory.
# ─────────────────────────────────────────────────────────────────────────────
do_list() {
  local source_branch="$1"
  local target_branch="$2"
  local exclude_file="${3:-}"

  check_prerequisites "$source_branch" "$target_branch"

  # Load exclusions if provided
  EXCLUDED_COMMITS=()
  if [[ -n "$exclude_file" ]]; then
    load_exclusions "$exclude_file"
  fi

  local target_safe
  target_safe=$(branch_to_filename "$target_branch")

  info "Listing commits not yet cherry-picked: $source_branch -> $target_branch"

  local candidates=()
  local excluded_count=0
  local already_picked=0

  while IFS= read -r line; do
    local sign hash
    sign=$(echo "$line" | awk '{print $1}')
    hash=$(echo "$line" | awk '{print $2}')
    if [[ "$sign" == "+" ]]; then
      if [[ ${#EXCLUDED_COMMITS[@]} -gt 0 ]] && is_excluded "$hash"; then
        excluded_count=$((excluded_count + 1))
      else
        candidates+=("$hash")
      fi
    else
      already_picked=$((already_picked + 1))
    fi
  done < <(git cherry "$target_branch" "$source_branch")

  local total=${#candidates[@]}
  local all_commits=$((total + excluded_count + already_picked))

  # Output file
  local out_file="cherry-pick-${target_safe}-candidates.txt"

  cat > "$out_file" <<HEADER
# Commits on $source_branch not yet cherry-picked into $target_branch
# Generated: $(date +%Y-%m-%d)
# Method: git cherry (patch-id comparison, no cherry-pick testing)
# Source branch: $source_branch ($(git rev-parse "$source_branch"))
# Target branch: $target_branch ($(git rev-parse "$target_branch"))
#
# Total commits on source:   $all_commits
# Already cherry-picked:     $already_picked
# Policy-excluded:           $excluded_count
# Candidates listed below:   $total
#
# Each line: <short-hash> <subject>

HEADER

  for hash in "${candidates[@]}"; do
    git log --oneline -1 "$hash" >> "$out_file"
  done

  echo ""
  info "═══════════════════════════════════════════════════"
  info "Commit list: $source_branch -> $target_branch"
  info "═══════════════════════════════════════════════════"
  info    "Total on source:     $all_commits"
  success "Already picked:      $already_picked"
  if (( excluded_count > 0 )); then
    info  "Policy-excluded:     $excluded_count"
  fi
  info    "Candidates:          $total"
  echo ""
  info "Written to: $out_file"
}

# ─────────────────────────────────────────────────────────────────────────────
# Mode: --analyze
# Discover which commits cherry-pick cleanly from source into target.
# Uses cumulative testing: oldest first, keeping successful picks on a
# temporary branch so later commits benefit from earlier ones.
# ─────────────────────────────────────────────────────────────────────────────
do_analyze() {
  local source_branch="$1"
  local target_branch="$2"
  local exclude_file="${3:-}"

  check_prerequisites "$source_branch" "$target_branch"

  # Load exclusions if provided
  EXCLUDED_COMMITS=()
  if [[ -n "$exclude_file" ]]; then
    load_exclusions "$exclude_file"
  fi

  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  local target_safe
  target_safe=$(branch_to_filename "$target_branch")

  info "Analyzing cherry-pick candidates: $source_branch -> $target_branch"
  info "Current branch: $current_branch"

  # Get candidates: commits on source not in target (by patch-id)
  info "Running git cherry to find un-cherry-picked commits..."
  local candidates=()
  local excluded_count=0
  local already_picked=0

  while IFS= read -r line; do
    local sign hash
    sign=$(echo "$line" | awk '{print $1}')
    hash=$(echo "$line" | awk '{print $2}')
    if [[ "$sign" == "+" ]]; then
      if [[ ${#EXCLUDED_COMMITS[@]} -gt 0 ]] && is_excluded "$hash"; then
        warn "Excluding (policy): $(git log --oneline -1 "$hash")"
        excluded_count=$((excluded_count + 1))
      else
        candidates+=("$hash")
      fi
    else
      already_picked=$((already_picked + 1))
    fi
  done < <(git cherry "$target_branch" "$source_branch")

  local total=${#candidates[@]}
  info "Commits on $source_branch:       $((total + excluded_count + already_picked))"
  info "Already cherry-picked:            $already_picked"
  if [[ $excluded_count -gt 0 ]]; then
    info "Policy-excluded:                  $excluded_count"
  fi
  info "Candidates to test:               $total"

  if [[ $total -eq 0 ]]; then
    info "Nothing to test. All commits are already cherry-picked or excluded."
    return 0
  fi

  # Create temporary test branch from target
  local test_branch="test-cherry-picks-$(date +%s)"
  info "Creating temporary test branch '$test_branch' from $target_branch..."
  git checkout -b "$test_branch" "$target_branch" --quiet

  # Output files
  local clean_file="cherry-pick-${target_safe}-clean.txt"
  local conflict_file="cherry-pick-${target_safe}-conflicts.txt"

  # Write headers
  cat > "$clean_file" <<HEADER
# Commits from $source_branch that can be cleanly cherry-picked into $target_branch
# Generated: $(date +%Y-%m-%d)
# Method: Cumulative cherry-pick testing (oldest first, keeping successful picks)
# Source branch: $source_branch ($(git rev-parse "$source_branch"))
# Target branch: $target_branch ($(git rev-parse "$target_branch"))
#
# ORDER MATTERS: These commits must be applied in the order listed below.
# Each line: <short-hash> <subject>

HEADER

  cat > "$conflict_file" <<HEADER
# Commits from $source_branch that CANNOT be cleanly cherry-picked into $target_branch
# Generated: $(date +%Y-%m-%d)
# Source branch: $source_branch ($(git rev-parse "$source_branch"))
# Target branch: $target_branch ($(git rev-parse "$target_branch"))
# Categories: CONFLICT (merge conflict), EMPTY (already applied differently)

HEADER

  local count=0
  local clean_count=0
  local conflict_count=0
  local empty_count=0

  for hash in "${candidates[@]}"; do
    count=$((count + 1))
    local subject
    subject=$(git log --oneline -1 "$hash")

    if git cherry-pick --no-commit "$hash" 2>/dev/null; then
      if git diff --cached --quiet; then
        # Empty - already applied via a different commit
        git reset --hard HEAD >/dev/null 2>&1
        echo "EMPTY: $subject" >> "$conflict_file"
        empty_count=$((empty_count + 1))
      else
        # Clean - commit and keep on the test branch for cumulative testing
        git commit --no-edit -m "$(git log --format='%s' -1 "$hash")" >/dev/null 2>&1
        echo "$subject" >> "$clean_file"
        clean_count=$((clean_count + 1))
      fi
    else
      git cherry-pick --abort 2>/dev/null || true
      git reset --hard HEAD >/dev/null 2>&1
      echo "CONFLICT: $subject" >> "$conflict_file"
      conflict_count=$((conflict_count + 1))
    fi

    if (( count % 20 == 0 )); then
      info "Progress: $count / $total  (clean: $clean_count, conflict: $conflict_count, empty: $empty_count)"
    fi
  done

  # Clean up test branch
  git checkout "$current_branch" --quiet
  git branch -D "$test_branch" --quiet 2>/dev/null || true

  echo ""
  info "═══════════════════════════════════════════════════"
  info "Analysis complete: $source_branch -> $target_branch"
  info "═══════════════════════════════════════════════════"
  success "Clean cherry-picks:  $clean_count"
  if (( conflict_count > 0 )); then
    warn  "Conflicts:           $conflict_count"
  fi
  if (( empty_count > 0 )); then
    info  "Empty (already in):  $empty_count"
  fi
  if (( excluded_count > 0 )); then
    info  "Policy-excluded:     $excluded_count"
  fi
  info    "Total tested:        $total"
  echo ""
  info "Results written to:"
  info "  $clean_file        (commits to cherry-pick, in order)"
  info "  $conflict_file     (commits needing manual work)"
}

# ─────────────────────────────────────────────────────────────────────────────
# Mode: --execute
# Apply cherry-picks from a previously generated list file.
# The file format is one commit per line: <short-hash> <subject>
# Lines starting with # are comments and are skipped.
# ─────────────────────────────────────────────────────────────────────────────
do_execute() {
  local target_branch="$1"
  local list_file="$2"

  if [[ ! -f "$list_file" ]]; then
    error "List file not found: $list_file"
    exit 1
  fi

  # Parse commits from the list file (skip comments and blank lines)
  local commits=()
  while IFS= read -r line; do
    # Skip comments and blank lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// /}" ]] && continue
    # Extract just the hash (first field)
    local hash
    hash=$(echo "$line" | awk '{print $1}')
    if [[ -n "$hash" ]]; then
      commits+=("$hash")
    fi
  done < "$list_file"

  local total=${#commits[@]}
  if [[ $total -eq 0 ]]; then
    error "No commits found in $list_file"
    exit 1
  fi

  # Only need to verify git repo and target branch for execute mode
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    error "Not inside a git repository."
    exit 1
  fi

  if ! git rev-parse --verify "$target_branch" &>/dev/null; then
    error "Branch '$target_branch' not found."
    exit 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    error "Working tree is not clean. Commit or stash your changes first."
    exit 1
  fi

  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$current_branch" != "$target_branch" ]]; then
    info "Checking out $target_branch..."
    git checkout "$target_branch"
  fi

  info "Applying $total cherry-picks to $target_branch from $list_file..."
  echo ""

  local count=0
  local applied=0
  local failed=0
  local failed_hashes=()

  for hash in "${commits[@]}"; do
    count=$((count + 1))
    local subject
    subject=$(git log --oneline -1 "$hash" 2>/dev/null || echo "$hash (commit not found)")

    printf "[%3d/%d] " "$count" "$total"

    if git cherry-pick "$hash" 2>/dev/null; then
      success "$subject"
      applied=$((applied + 1))
    else
      error "$subject"
      failed=$((failed + 1))
      failed_hashes+=("$hash")
      # Abort and continue with next
      git cherry-pick --abort 2>/dev/null || true
      warn "  Skipping due to conflict (may need re-analysis)"
    fi
  done

  echo ""
  info "═══════════════════════════════════════════════════"
  info "Execution complete"
  info "═══════════════════════════════════════════════════"
  success "Applied:  $applied / $total"
  if (( failed > 0 )); then
    error "Failed:   $failed / $total"
    warn  "Some commits failed. Run --analyze to refresh the list."
    echo ""
    warn  "Failed commits:"
    for fh in "${failed_hashes[@]}"; do
      warn "  $(git log --oneline -1 "$fh" 2>/dev/null || echo "$fh")"
    done
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Mode: --help
# ─────────────────────────────────────────────────────────────────────────────
do_help() {
  cat <<HELP
${BOLD}$SCRIPT_NAME${NC} v$VERSION - Generic git cherry-pick assistant

${BOLD}USAGE:${NC}
  $SCRIPT_NAME --list    <source-branch> <target-branch> [--exclude <file>]
  $SCRIPT_NAME --analyze <source-branch> <target-branch> [--exclude <file>]
  $SCRIPT_NAME --execute <target-branch> <list-file>
  $SCRIPT_NAME --help

${BOLD}MODES:${NC}
  ${BOLD}--list <source> <target> [--exclude <file>]${NC}
      Export the full list of commits on <source> that are not yet on
      <target> (compared by patch-id via \`git cherry\`).  This is a
      fast inventory — no cherry-pick testing is performed.

      Produces one output file:
        cherry-pick-<target>-candidates.txt  All differing commits (oldest first)

      Useful as a quick overview before running the slower --analyze.

  ${BOLD}--analyze <source> <target> [--exclude <file>]${NC}
      Discover which commits from <source> can be cleanly cherry-picked
      into <target>.  Uses cumulative testing: applies cherry-picks
      oldest-first on a temporary branch, keeping successful ones so
      later commits benefit from earlier changes.

      Produces two output files:
        cherry-pick-<target>-clean.txt       Commits that apply cleanly (in order)
        cherry-pick-<target>-conflicts.txt   Commits that conflict or are empty

      The --exclude option takes a file containing commit hashes to skip
      (one per line, # comments allowed).

      This mode does NOT modify the target branch.

  ${BOLD}--execute <target> <list-file>${NC}
      Apply cherry-picks listed in <list-file> to <target-branch>.
      The list file should be in the format produced by --analyze
      (one commit per line: <hash> <subject>, # comments skipped).

      This mode MODIFIES the target branch.

  ${BOLD}--help${NC}
      Show this help message.

${BOLD}EXAMPLES:${NC}
  # Quick inventory: what commits are on main but not release-2.0?
  ./$SCRIPT_NAME --list main release-2.0

  # Analyze what can be cherry-picked from main into release-2.0
  ./$SCRIPT_NAME --analyze main release-2.0

  # Same, but exclude specific commits
  echo "abc1234  # skip this release commit" > exclude.txt
  ./$SCRIPT_NAME --analyze main release-2.0 --exclude exclude.txt

  # Apply the clean commits found by --analyze
  ./$SCRIPT_NAME --execute release-2.0 cherry-pick-release-2.0-clean.txt

${BOLD}EXCLUSION FILE FORMAT:${NC}
  One commit hash per line (short or full). Inline comments with #.
  Example:
    # Policy exclusions - never cherry-pick these
    abc1234def567890  # Release version bump
    fedcba9876543210  # Branch-specific change

${BOLD}HOW IT WORKS:${NC}
  The --analyze mode uses \`git cherry <target> <source>\` to identify
  commits on the source branch that have not been cherry-picked into
  the target branch (compared by patch-id, so it detects commits that
  were cherry-picked even if their SHA differs).

  Candidates are then tested oldest-first on a temporary branch forked
  from the target.  Successfully picked commits are kept on the
  temporary branch, which allows later commits that depend on earlier
  ones to succeed (cumulative testing).  The temporary branch is
  deleted at the end; the real target branch is never modified.

  Three outcomes per commit:
    CLEAN    - Cherry-pick applies without conflict
    CONFLICT - Cherry-pick causes merge conflicts
    EMPTY    - Cherry-pick produces no changes (already applied differently)

${BOLD}NOTES:${NC}
  - The working tree must be clean (no uncommitted changes).
  - Both source and target branches must exist locally.
  - For --analyze, the order of commits in the clean list matters.
    Apply them in the listed order to avoid conflicts.
  - If the source branch has advanced since the last --analyze run,
    re-run --analyze to discover new candidates.
HELP
}

# ─────────────────────────────────────────────────────────────────────────────
# Argument parsing
# ─────────────────────────────────────────────────────────────────────────────
if [[ $# -eq 0 ]]; then
  error "No arguments provided."
  echo ""
  do_help
  exit 1
fi

case "$1" in
  --list)
    if [[ $# -lt 3 ]]; then
      error "Usage: $SCRIPT_NAME --list <source-branch> <target-branch> [--exclude <file>]"
      exit 1
    fi
    source_branch="$2"
    target_branch="$3"
    exclude_file=""

    shift 3
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --exclude)
          if [[ $# -lt 2 ]]; then
            error "--exclude requires a file argument"
            exit 1
          fi
          exclude_file="$2"
          shift 2
          ;;
        *)
          error "Unknown option: $1"
          exit 1
          ;;
      esac
    done

    do_list "$source_branch" "$target_branch" "$exclude_file"
    ;;

  --analyze)
    if [[ $# -lt 3 ]]; then
      error "Usage: $SCRIPT_NAME --analyze <source-branch> <target-branch> [--exclude <file>]"
      exit 1
    fi
    source_branch="$2"
    target_branch="$3"
    exclude_file=""

    # Parse optional --exclude flag
    shift 3
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --exclude)
          if [[ $# -lt 2 ]]; then
            error "--exclude requires a file argument"
            exit 1
          fi
          exclude_file="$2"
          shift 2
          ;;
        *)
          error "Unknown option: $1"
          exit 1
          ;;
      esac
    done

    do_analyze "$source_branch" "$target_branch" "$exclude_file"
    ;;

  --execute)
    if [[ $# -lt 3 ]]; then
      error "Usage: $SCRIPT_NAME --execute <target-branch> <list-file>"
      exit 1
    fi
    do_execute "$2" "$3"
    ;;

  --help|-h)
    do_help
    ;;

  --version|-v)
    echo "$SCRIPT_NAME v$VERSION"
    ;;

  *)
    error "Unknown command: $1"
    echo ""
    error "Usage: $SCRIPT_NAME {--list|--analyze|--execute|--help}"
    exit 1
    ;;
esac
