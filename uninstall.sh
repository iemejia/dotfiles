#!/usr/bin/env bash
# Uninstall (unstow) dotfile packages
# Usage: ./uninstall.sh [package...]

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <package...>"
    echo "Available packages:"
    for d in */; do
        [ -d "$d" ] && echo "  ${d%/}"
    done
    exit 1
fi

for pkg in "$@"; do
    if [ "$pkg" = "ssh" ]; then
        echo "Removing ssh config symlink..."
        rm -fv ~/.ssh/config
        # Remove config.d only if empty (preserve user-created host files)
        rmdir ~/.ssh/config.d 2>/dev/null && echo "Removed empty ~/.ssh/config.d/" || true
    elif [ -d "$pkg" ]; then
        echo "Unstowing $pkg..."
        stow -v --target="$HOME" --delete "$pkg"
    else
        echo "Warning: package '$pkg' not found"
    fi
done
