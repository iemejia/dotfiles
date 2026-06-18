#!/usr/bin/env bash
# git-cleanup-merged-branch.sh — Delete local and remote branches for a merged PR.
#
# Usage:
#   git cleanup-merged-branch <branch> <remote> [--dry-run]
#
# Arguments:
#   branch        Branch name to clean up (required)
#   remote        Remote name where the branch was pushed (required)
#   --dry-run, -n Show what would be done without making changes
#
# Examples:
#   git cleanup-merged-branch fix/my-bug origin
#   git cleanup-merged-branch feature/new-api myfork --dry-run

set -euo pipefail

die() { printf 'error: %s\n' "$1" >&2; exit 1; }

usage() {
    printf 'Usage: git cleanup-merged-branch <branch> <remote> [--dry-run]\n\n'
    printf 'Delete local and remote branches after a GitHub PR has been merged.\n'
    printf 'Verifies the PR was merged via gh before deleting anything.\n\n'
    printf 'Arguments:\n'
    printf '  branch        Branch name to clean up\n'
    printf '  remote        Remote name where the branch was pushed (e.g. origin, myfork)\n\n'
    printf 'Options:\n'
    printf '  -n, --dry-run Show what would be done without making changes\n'
    printf '  -h, --help    Show this help message\n\n'
    printf 'Examples:\n'
    printf '  git cleanup-merged-branch fix/my-bug origin\n'
    printf '  git cleanup-merged-branch feature/new-api myfork --dry-run\n\n'
    printf 'Available remotes:\n'
    git remote -v 2>/dev/null | sed 's/^/  /' || printf '  (not in a git repository)\n'
    printf '\nLocal branches:\n'
    git branch 2>/dev/null | sed 's/^/  /' || printf '  (not in a git repository)\n'
}

# --- Parse arguments ---
BRANCH=""
REMOTE=""
DRY_RUN=false
POSITIONAL=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run) DRY_RUN=true; shift ;;
        -h|--help)    usage; exit 0 ;;
        -*)           die "unknown option: $1" ;;
        *)            POSITIONAL+=("$1"); shift ;;
    esac
done

# --- Require tools ---
command -v gh >/dev/null 2>&1 || die "gh (GitHub CLI) is required"
command -v git >/dev/null 2>&1 || die "git is required"

# --- Require both positional arguments ---
if [[ ${#POSITIONAL[@]} -lt 2 ]]; then
    usage
    printf '\n'
    die "both <branch> and <remote> are required"
fi

BRANCH="${POSITIONAL[0]}"
REMOTE="${POSITIONAL[1]}"

[[ "$BRANCH" != "main" && "$BRANCH" != "master" ]] || die "refusing to delete '$BRANCH'"
git remote | grep -qx "$REMOTE" || die "remote '$REMOTE' does not exist"

# --- Check PR merge status ---
PR_JSON=$(gh pr list --head "$BRANCH" --state merged --json number,title,mergedAt --limit 1)
PR_COUNT=$(printf '%s' "$PR_JSON" | jq 'length')

if [[ "$PR_COUNT" -eq 0 ]]; then
    die "no merged PR found for branch '$BRANCH' — aborting"
fi

PR_NUMBER=$(printf '%s' "$PR_JSON" | jq -r '.[0].number')
PR_TITLE=$(printf '%s' "$PR_JSON" | jq -r '.[0].title')
PR_MERGED=$(printf '%s' "$PR_JSON" | jq -r '.[0].mergedAt')

printf 'PR #%s merged at %s\n  %s\n\n' "$PR_NUMBER" "$PR_MERGED" "$PR_TITLE"

# --- Switch off the branch if we're on it ---
CURRENT=$(git branch --show-current)
if [[ "$CURRENT" == "$BRANCH" ]]; then
    DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||' || echo "main")
    if $DRY_RUN; then
        printf '[dry-run] would switch to %s\n' "$DEFAULT"
    else
        printf 'Switching to %s...\n' "$DEFAULT"
        git checkout "$DEFAULT"
    fi
fi

# --- Delete local branch ---
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    if $DRY_RUN; then
        printf '[dry-run] would delete local branch %s\n' "$BRANCH"
    else
        git branch -D "$BRANCH"
        printf 'Deleted local branch %s\n' "$BRANCH"
    fi
else
    printf 'Local branch %s does not exist — skipping\n' "$BRANCH"
fi

# --- Delete remote branch ---
if git ls-remote --exit-code --heads "$REMOTE" "$BRANCH" >/dev/null 2>&1; then
    if $DRY_RUN; then
        printf '[dry-run] would delete remote branch %s/%s\n' "$REMOTE" "$BRANCH"
    else
        git push "$REMOTE" --delete "$BRANCH"
        printf 'Deleted remote branch %s/%s\n' "$REMOTE" "$BRANCH"
    fi
else
    printf 'Remote branch %s/%s does not exist — skipping\n' "$REMOTE" "$BRANCH"
fi

# --- Prune stale remote-tracking refs ---
if $DRY_RUN; then
    printf '[dry-run] would prune remote-tracking refs for %s\n' "$REMOTE"
else
    git remote prune "$REMOTE"
fi

printf '\nDone.\n'
