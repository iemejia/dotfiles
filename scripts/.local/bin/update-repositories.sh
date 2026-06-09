#!/bin/bash
set -euo pipefail

# Directories containing git repositories
GIT_DIRS=(
	~/apache
	~/msrepos
	~/msrepos-old
	~/repositories
	~/projects
)

# Directories containing svn repositories
SVN_DIRS=(
	~/svnprojects
)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
failures=0
updated=0
up_to_date=0
skipped=0

updated_repos=()
skipped_repos=()
failed_repos=()

update_git_repo() {
	local dir="$1"
	if [ ! -e "$dir/.git" ]; then
		echo -e "${YELLOW}[SKIP]${NC} $dir (not a git repo)"
		skipped_repos+=("$dir (not a git repo)")
		skipped=$((skipped + 1))
		return 0
	fi

	local head_before
	head_before=$(git -C "$dir" rev-parse HEAD 2>/dev/null)

	local fetch_output
	if ! fetch_output=$(git -C "$dir" fetch -p --all --quiet 2>&1); then
		echo -e "${RED}[FAIL]${NC} $dir: fetch failed"
		failed_repos+=("$dir (fetch failed)")
		return 1
	fi

	local pull_failed=false
	local has_upstream
	has_upstream=$(git -C "$dir" rev-parse --abbrev-ref "@{upstream}" 2>/dev/null || echo "")

	if [ -z "$has_upstream" ]; then
		echo -e "${YELLOW}[SKIP]${NC} $dir (no upstream tracking)"
		skipped_repos+=("$dir (no upstream tracking)")
		# Still fast-forward other branches that may have tracking
		ff_other_branches "$dir"
		return 0
	fi

	local pull_output
	if ! pull_output=$(git -C "$dir" -c advice.diverging=false pull --ff-only --quiet 2>&1); then
		echo -e "${YELLOW}[WARN]${NC} $dir: pull failed (local commits or dirty tree?)"
		pull_failed=true
		failed_repos+=("$dir (pull failed)")
	fi

	# Fast-forward other local branches that are behind their upstream
	ff_other_branches "$dir"

	if [ "$pull_failed" = true ]; then
		return 1
	fi

	local head_after
	head_after=$(git -C "$dir" rev-parse HEAD 2>/dev/null)

	if [ "$head_before" != "$head_after" ]; then
		local count
		count=$(git -C "$dir" log --oneline "$head_before".."$head_after" | wc -l | tr -d ' ')
		echo -e "${CYAN}[UPDATED]${NC} $dir ${GREEN}(+${count} commit(s))${NC}"
		updated_repos+=("$dir (+${count})")
		updated=$((updated + 1))
	else
		echo -e "${BLUE}[OK]${NC} $dir (up to date)"
		up_to_date=$((up_to_date + 1))
	fi
}

ff_other_branches() {
	local dir="$1"

	# Get branches checked out in worktrees (cannot update these)
	local -a worktree_branches=()
	while IFS= read -r line; do
		if [[ "$line" == branch\ * ]]; then
			# Extract branch name from "branch refs/heads/foo"
			worktree_branches+=("${line#branch refs/heads/}")
		fi
	done < <(git -C "$dir" worktree list --porcelain 2>/dev/null)

	local current_branch
	current_branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || echo "")

	# Iterate all local branches with their upstream
	while IFS=' ' read -r branch upstream; do
		[ -n "$upstream" ] || continue
		[ "$branch" != "$current_branch" ] || continue

		# Skip branches checked out in worktrees
		local in_worktree=false
		for wt_branch in "${worktree_branches[@]+"${worktree_branches[@]}"}"; do
			if [ "$branch" = "$wt_branch" ]; then
				in_worktree=true
				break
			fi
		done
		if [ "$in_worktree" = true ]; then
			continue
		fi

		local local_ref remote_ref
		local_ref=$(git -C "$dir" rev-parse "refs/heads/$branch" 2>/dev/null) || continue
		remote_ref=$(git -C "$dir" rev-parse "refs/remotes/$upstream" 2>/dev/null) || continue

		# Skip if already up to date
		[ "$local_ref" != "$remote_ref" ] || continue

		# Only fast-forward: local must be ancestor of remote
		if git -C "$dir" merge-base --is-ancestor "$local_ref" "$remote_ref" 2>/dev/null; then
			git -C "$dir" update-ref "refs/heads/$branch" "$remote_ref" "$local_ref"
			echo -e "    ${GREEN}[FF]${NC} $branch -> $upstream"
		fi
	done < <(git -C "$dir" for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads/)
}

update_svn_repo() {
	local dir="$1"
	if [ ! -d "$dir/.svn" ]; then
		echo -e "${YELLOW}[SKIP]${NC} $dir (not an svn repo)"
		skipped_repos+=("$dir (not an svn repo)")
		skipped=$((skipped + 1))
		return 0
	fi

	local rev_before
	rev_before=$(svn info "$dir" --show-item revision 2>/dev/null)

	if ! svn update "$dir" --quiet --non-interactive 2>&1; then
		echo -e "${RED}[FAIL]${NC} $dir: svn update failed"
		failed_repos+=("$dir (svn update failed)")
		return 1
	fi

	local rev_after
	rev_after=$(svn info "$dir" --show-item revision 2>/dev/null)

	if [ "$rev_before" != "$rev_after" ]; then
		echo -e "${CYAN}[UPDATED]${NC} $dir ${GREEN}(r${rev_before} -> r${rev_after})${NC}"
		updated_repos+=("$dir (r${rev_before}->r${rev_after})")
		updated=$((updated + 1))
	else
		echo -e "${BLUE}[OK]${NC} $dir (up to date)"
		up_to_date=$((up_to_date + 1))
	fi
}

for parent in "${GIT_DIRS[@]}"; do
	[ -d "$parent" ] || continue
	for d in "$parent"/*/; do
		[ -d "$d" ] || continue
		update_git_repo "$d" || failures=$((failures + 1))
	done
done

for parent in "${SVN_DIRS[@]}"; do
	[ -d "$parent" ] || continue
	for d in "$parent"/*/; do
		[ -d "$d" ] || continue
		update_svn_repo "$d" || failures=$((failures + 1))
	done
done

# Summary
echo ""
echo "─────────────────────────────────"
echo -e " ${CYAN}Updated:${NC}    $updated"
echo -e " ${BLUE}Up to date:${NC} $up_to_date"
echo -e " ${YELLOW}Skipped:${NC}    $skipped"
echo -e " ${RED}Failed:${NC}     $failures"
echo "─────────────────────────────────"

if [ ${#updated_repos[@]} -gt 0 ]; then
	echo ""
	echo -e "${CYAN}Repos with new changes:${NC}"
	for repo in "${updated_repos[@]}"; do
		echo "  • $repo"
	done
fi

if [ ${#skipped_repos[@]} -gt 0 ]; then
	echo ""
	echo -e "${YELLOW}Skipped repos:${NC}"
	for repo in "${skipped_repos[@]}"; do
		echo "  • $repo"
	done
fi

if [ ${#failed_repos[@]} -gt 0 ]; then
	echo ""
	echo -e "${RED}Failed repos:${NC}"
	for repo in "${failed_repos[@]}"; do
		echo "  • $repo"
	done
fi

if [ "$failures" -gt 0 ]; then
	exit 1
fi
