#!/bin/bash
set -uo pipefail

# Options
do_pull=false
for arg in "$@"; do
	case "$arg" in
		--pull|-p) do_pull=true ;;
		--help|-h)
			echo "Usage: $(basename "$0") [OPTIONS]"
			echo ""
			echo "Options:"
			echo "  -p, --pull   Pull repos that are behind their upstream"
			echo "  -h, --help   Show this help message"
			exit 0
			;;
		*)
			echo "Unknown option: $arg" >&2
			exit 1
			;;
	esac
done

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
clean=0
needs_commit=0
needs_push=0
needs_pull=0
diverged=0
issues=0

declare -a repos_commit=()
declare -a repos_push=()
declare -a repos_pull=()
declare -a repos_diverged=()
declare -a repos_issues=()
declare -a all_repos=()

for d in */; do
	[ -d "$d" ] || continue
	[ -d "$d/.git" ] || continue
	dir="${d%/}"
	all_repos+=("$dir")

	# Check for uncommitted changes (staged, unstaged, untracked)
	staged=$(git -C "$dir" diff --cached --quiet 2>/dev/null; echo $?)
	unstaged=$(git -C "$dir" diff --quiet 2>/dev/null; echo $?)
	untracked=$(git -C "$dir" ls-files --others --exclude-standard 2>/dev/null | head -1)
	stashes=$(git -C "$dir" stash list 2>/dev/null | wc -l | tr -d ' ')

	has_local_changes=false
	if [ "$staged" -ne 0 ] || [ "$unstaged" -ne 0 ] || [ -n "$untracked" ]; then
		has_local_changes=true
	fi

	# Check upstream status
	branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || echo "")
	upstream_status=""
	ahead=0
	behind=0

	if [ -n "$branch" ]; then
		upstream=$(git -C "$dir" rev-parse --abbrev-ref "@{upstream}" 2>/dev/null || echo "")
		if [ -n "$upstream" ]; then
			ahead=$(git -C "$dir" rev-list --count "@{upstream}..HEAD" 2>/dev/null || echo 0)
			behind=$(git -C "$dir" rev-list --count "HEAD..@{upstream}" 2>/dev/null || echo 0)

			if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
				upstream_status="diverged"
			elif [ "$ahead" -gt 0 ]; then
				upstream_status="ahead"
			elif [ "$behind" -gt 0 ]; then
				upstream_status="behind"
			fi
		fi
	fi

	# Classify
	if [ "$has_local_changes" = true ] && [ "$upstream_status" = "diverged" ]; then
		echo -e "${RED}[DIVERGED+DIRTY]${NC} $dir (ahead $ahead, behind $behind, uncommitted changes)"
		repos_issues+=("$dir")
		issues=$((issues + 1))
	elif [ "$upstream_status" = "diverged" ]; then
		echo -e "${RED}[DIVERGED]${NC} $dir (ahead $ahead, behind $behind)"
		repos_diverged+=("$dir")
		diverged=$((diverged + 1))
	elif [ "$has_local_changes" = true ] && [ "$upstream_status" = "ahead" ]; then
		echo -e "${YELLOW}[COMMIT+PUSH]${NC} $dir (uncommitted changes + $ahead unpushed)"
		repos_issues+=("$dir")
		issues=$((issues + 1))
	elif [ "$has_local_changes" = true ]; then
		echo -e "${YELLOW}[NEEDS COMMIT]${NC} $dir"
		repos_commit+=("$dir")
		needs_commit=$((needs_commit + 1))
	elif [ "$upstream_status" = "ahead" ]; then
		echo -e "${CYAN}[NEEDS PUSH]${NC} $dir ($ahead commit(s) ahead)"
		repos_push+=("$dir")
		needs_push=$((needs_push + 1))
	elif [ "$upstream_status" = "behind" ]; then
		echo -e "${CYAN}[NEEDS PULL]${NC} $dir ($behind commit(s) behind)"
		repos_pull+=("$dir")
		needs_pull=$((needs_pull + 1))
	else
		if [ "$stashes" -gt 0 ]; then
			echo -e "${GREEN}[CLEAN]${NC} $dir (${YELLOW}$stashes stash(es)${NC})"
		else
			echo -e "${GREEN}[CLEAN]${NC} $dir"
		fi
		clean=$((clean + 1))
	fi
done

# Summary
echo ""
echo "─────────────────────────────────"
echo -e " ${GREEN}Clean:${NC}        $clean"
echo -e " ${YELLOW}Needs commit:${NC} $needs_commit"
echo -e " ${CYAN}Needs push:${NC}   $needs_push"
echo -e " ${CYAN}Needs pull:${NC}   $needs_pull"
echo -e " ${RED}Diverged:${NC}     $diverged"
echo -e " ${RED}Issues:${NC}       $issues"
echo "─────────────────────────────────"

# Action items
if [ $((needs_commit + needs_push + diverged + issues)) -gt 0 ]; then
	echo ""
	echo -e "${YELLOW}Action required:${NC}"
	for r in "${repos_commit[@]+"${repos_commit[@]}"}"; do
		echo -e "  ${YELLOW}commit${NC}  $r"
	done
	for r in "${repos_push[@]+"${repos_push[@]}"}"; do
		echo -e "  ${CYAN}push${NC}    $r"
	done
	for r in "${repos_pull[@]+"${repos_pull[@]}"}"; do
		echo -e "  ${CYAN}pull${NC}    $r"
	done
	for r in "${repos_diverged[@]+"${repos_diverged[@]}"}"; do
		echo -e "  ${RED}rebase${NC}  $r"
	done
	for r in "${repos_issues[@]+"${repos_issues[@]}"}"; do
		echo -e "  ${RED}fix${NC}     $r"
	done
fi

ff_other_branches() {
	local dir="$1"

	# Get branches checked out in worktrees (cannot update these)
	local -a worktree_branches=()
	while IFS= read -r line; do
		if [[ "$line" == branch\ * ]]; then
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
			echo -e "    ${GREEN}[FF]${NC} $dir: $branch -> $upstream"
			local_ff=$((local_ff + 1))
		fi
	done < <(git -C "$dir" for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads/)
}

# Auto-pull if requested
if [ "$do_pull" = true ]; then
	if [ ${#repos_pull[@]} -gt 0 ]; then
		echo ""
		echo -e "${CYAN}Pulling ${#repos_pull[@]} repo(s)...${NC}"
		for r in "${repos_pull[@]}"; do
			echo -n "  $r: "
			if git -C "$r" pull --ff-only 2>/dev/null; then
				echo -e "${GREEN}done${NC}"
			else
				echo -e "${RED}failed (try manual pull/rebase)${NC}"
			fi
		done
	fi

	# Fast-forward non-checked-out branches in all repos
	echo ""
	echo -e "${CYAN}Fast-forwarding other local branches...${NC}"
	local_ff=0
	for r in "${all_repos[@]}"; do
		# Fetch to ensure remote-tracking refs are current
		git -C "$r" fetch --all --quiet 2>/dev/null || true
		ff_other_branches "$r"
	done
	if [ "$local_ff" -eq 0 ]; then
		echo -e "  ${GREEN}All branches up to date.${NC}"
	fi
fi
