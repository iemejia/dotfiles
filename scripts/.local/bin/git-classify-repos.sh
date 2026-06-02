#!/bin/bash
# classify-repos.sh
# Scans subdirectories for git repos, extracts origin remote URLs,
# and classifies them as PUBLIC, PRIVATE, or NOT_FOUND using the gh CLI.
#
# Requirements: git, gh (authenticated)
# Usage: ./classify-repos.sh [directory] [output_file]

DIR="${1:-.}"
OUTPUT="${2:-git-remotes.txt}"

# Check dependencies
if ! command -v gh &>/dev/null; then
  echo "Error: 'gh' CLI is required. Install from https://cli.github.com/" >&2
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "Error: 'gh' is not authenticated. Run 'gh auth login' first." >&2
  exit 1
fi

declare -a PUBLIC=()
declare -a PRIVATE=()
declare -a NOT_FOUND=()
declare -a NON_GITHUB=()

echo "Scanning directories in: $DIR"
echo ""

for dir in "$DIR"/*/; do
  [ ! -d "$dir/.git" ] && continue

  url=$(git -C "$dir" remote get-url origin 2>/dev/null)
  [ -z "$url" ] && continue

  # Normalize URL: remove .git suffix and trailing slash
  clean_url=$(echo "$url" | sed 's|\.git$||; s|/$||')

  # Extract owner/repo from GitHub URLs
  repo_path=$(echo "$clean_url" | sed -n 's|.*github\.com[:/]\(.*\)|\1|p')

  if [ -z "$repo_path" ]; then
    NON_GITHUB+=("$clean_url")
    echo "  [NON-GITHUB] $clean_url"
    continue
  fi

  # Query GitHub via gh CLI
  visibility=$(gh repo view "$repo_path" --json visibility -q '.visibility' 2>&1)

  if echo "$visibility" | grep -qi "not found\|Could not resolve"; then
    NOT_FOUND+=("$clean_url")
    echo "  [NOT FOUND]  $clean_url"
  elif echo "$visibility" | grep -qi "PRIVATE"; then
    PRIVATE+=("$clean_url")
    echo "  [PRIVATE]    $clean_url"
  elif echo "$visibility" | grep -qi "INTERNAL"; then
    PRIVATE+=("$clean_url")
    echo "  [INTERNAL]   $clean_url"
  else
    PUBLIC+=("$clean_url")
    echo "  [PUBLIC]     $clean_url"
  fi
done

# Write output file
{
  echo "Git Remote URLs - Classification by Accessibility"
  echo "=================================================="
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  echo "====================================="
  echo "PUBLIC REPOSITORIES (${#PUBLIC[@]})"
  echo "====================================="
  for url in "${PUBLIC[@]}"; do echo "$url"; done
  echo ""
  echo "====================================="
  echo "PRIVATE / ORG-LEVEL REPOSITORIES (${#PRIVATE[@]})"
  echo "====================================="
  for url in "${PRIVATE[@]}"; do echo "$url"; done
  echo ""
  echo "====================================="
  echo "NOT FOUND - Deleted or Renamed (${#NOT_FOUND[@]})"
  echo "====================================="
  for url in "${NOT_FOUND[@]}"; do echo "$url"; done

  if [ ${#NON_GITHUB[@]} -gt 0 ]; then
    echo ""
    echo "====================================="
    echo "NON-GITHUB REMOTES (${#NON_GITHUB[@]})"
    echo "====================================="
    for url in "${NON_GITHUB[@]}"; do echo "$url"; done
  fi

  echo ""
  echo "====================================="
  echo "SUMMARY"
  echo "====================================="
  total=$(( ${#PUBLIC[@]} + ${#PRIVATE[@]} + ${#NOT_FOUND[@]} + ${#NON_GITHUB[@]} ))
  echo "Total repositories: $total"
  echo "Public: ${#PUBLIC[@]}"
  echo "Private/Org-level: ${#PRIVATE[@]}"
  echo "Not Found: ${#NOT_FOUND[@]}"
  [ ${#NON_GITHUB[@]} -gt 0 ] && echo "Non-GitHub: ${#NON_GITHUB[@]}"
} > "$OUTPUT"

echo ""
echo "====================================="
echo "SUMMARY"
echo "====================================="
echo "Total: $(( ${#PUBLIC[@]} + ${#PRIVATE[@]} + ${#NOT_FOUND[@]} + ${#NON_GITHUB[@]} ))"
echo "Public: ${#PUBLIC[@]}"
echo "Private/Org-level: ${#PRIVATE[@]}"
echo "Not Found: ${#NOT_FOUND[@]}"
[ ${#NON_GITHUB[@]} -gt 0 ] && echo "Non-GitHub: ${#NON_GITHUB[@]}"
echo ""
echo "Results written to: $OUTPUT"
