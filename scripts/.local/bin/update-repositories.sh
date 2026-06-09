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

update_git_repo() {
	local dir="$1"
	if [ ! -d "$dir/.git" ]; then
		echo -e "${YELLOW}[SKIP]${NC} $dir (not a git repo)"
		((skipped++))
		return 0
	fi

	local head_before
	head_before=$(git -C "$dir" rev-parse HEAD 2>/dev/null)

	if ! git -C "$dir" fetch -p --all --quiet 2>&1; then
		echo -e "${RED}[FAIL]${NC} $dir: fetch failed"
		return 1
	fi
	if ! git -C "$dir" pull --ff-only --quiet 2>&1; then
		echo -e "${RED}[FAIL]${NC} $dir: pull failed (local commits or dirty tree?)"
		return 1
	fi

	local head_after
	head_after=$(git -C "$dir" rev-parse HEAD 2>/dev/null)

	if [ "$head_before" != "$head_after" ]; then
		local count
		count=$(git -C "$dir" log --oneline "$head_before".."$head_after" | wc -l | tr -d ' ')
		echo -e "${CYAN}[UPDATED]${NC} $dir ${GREEN}(+${count} commit(s))${NC}"
		updated_repos+=("$dir (+${count})")
		((updated++))
	else
		echo -e "${BLUE}[OK]${NC} $dir (up to date)"
		((up_to_date++))
	fi
}

update_svn_repo() {
	local dir="$1"
	if [ ! -d "$dir/.svn" ]; then
		echo -e "${YELLOW}[SKIP]${NC} $dir (not an svn repo)"
		((skipped++))
		return 0
	fi

	local rev_before
	rev_before=$(svn info "$dir" --show-item revision 2>/dev/null)

	if ! svn update "$dir" --quiet 2>&1; then
		echo -e "${RED}[FAIL]${NC} $dir: svn update failed"
		return 1
	fi

	local rev_after
	rev_after=$(svn info "$dir" --show-item revision 2>/dev/null)

	if [ "$rev_before" != "$rev_after" ]; then
		echo -e "${CYAN}[UPDATED]${NC} $dir ${GREEN}(r${rev_before} -> r${rev_after})${NC}"
		updated_repos+=("$dir (r${rev_before}->r${rev_after})")
		((updated++))
	else
		echo -e "${BLUE}[OK]${NC} $dir (up to date)"
		((up_to_date++))
	fi
}

for parent in "${GIT_DIRS[@]}"; do
	[ -d "$parent" ] || continue
	for d in "$parent"/*/; do
		[ -d "$d" ] || continue
		update_git_repo "$d" || ((failures++))
	done
done

for parent in "${SVN_DIRS[@]}"; do
	[ -d "$parent" ] || continue
	for d in "$parent"/*/; do
		[ -d "$d" ] || continue
		update_svn_repo "$d" || ((failures++))
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

if [ "$failures" -gt 0 ]; then
	exit 1
fi
