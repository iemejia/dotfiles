#!/bin/bash

# Exit on errors
set -e

# Check dependencies
command -v git >/dev/null 2>&1 || { echo >&2 "Git is not installed. Aborting."; exit 1; }

# Check Git version
MIN_GIT_VERSION="2.29.0"
INSTALLED_VERSION=$(git version | awk '{print $3}')

if [ "$(printf '%s\n' "$MIN_GIT_VERSION" "$INSTALLED_VERSION" | sort -V | head -n1)" != "$MIN_GIT_VERSION" ]; then
  echo "Git version must be >= $MIN_GIT_VERSION (you have $INSTALLED_VERSION)"
  exit 1
fi

# Read arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <source-repo-url-or-path> <destination-path>"
  exit 1
fi

SRC_REPO="$1"
DEST_REPO="$2"

# Temp directory for mirror clone
TMP_DIR=$(mktemp -d)

echo "📦 Cloning source repository..."
git clone --mirror "$SRC_REPO" "$TMP_DIR/old-repo"

echo "🆕 Creating new SHA-256 repository..."
export GIT_DEFAULT_HASH=sha256
git init --bare --object-format=sha256 "$DEST_REPO"

echo "🚀 Pushing contents to new SHA-256 repository..."
cd "$TMP_DIR/old-repo"
git push --mirror "$DEST_REPO"

echo "✅ Migration complete!"
echo "🔍 Verifying object format:"
cd "$DEST_REPO"
git config --get extensions.objectFormat

# Cleanup
rm -rf "$TMP_DIR"
