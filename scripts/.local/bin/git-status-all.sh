#!/bin/bash
set -euo pipefail

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

for d in */; do
	[ -d "$d/.git" ] || continue
	dir="${d%/}"

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
		((issues++))
	elif [ "$upstream_status" = "diverged" ]; then
		echo -e "${RED}[DIVERGED]${NC} $dir (ahead $ahead, behind $behind)"
		repos_diverged+=("$dir")
		((diverged++))
	elif [ "$has_local_changes" = true ] && [ "$upstream_status" = "ahead" ]; then
		echo -e "${YELLOW}[COMMIT+PUSH]${NC} $dir (uncommitted changes + $ahead unpushed)"
		repos_issues+=("$dir")
		((issues++))
	elif [ "$has_local_changes" = true ]; then
		echo -e "${YELLOW}[NEEDS COMMIT]${NC} $dir"
		repos_commit+=("$dir")
		((needs_commit++))
	elif [ "$upstream_status" = "ahead" ]; then
		echo -e "${CYAN}[NEEDS PUSH]${NC} $dir ($ahead commit(s) ahead)"
		repos_push+=("$dir")
		((needs_push++))
	elif [ "$upstream_status" = "behind" ]; then
		echo -e "${CYAN}[NEEDS PULL]${NC} $dir ($behind commit(s) behind)"
		repos_pull+=("$dir")
		((needs_pull++))
	else
		if [ "$stashes" -gt 0 ]; then
			echo -e "${GREEN}[CLEAN]${NC} $dir (${YELLOW}$stashes stash(es)${NC})"
		else
			echo -e "${GREEN}[CLEAN]${NC} $dir"
		fi
		((clean++))
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
