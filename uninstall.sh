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
    elif [ -d "$pkg" ]; then
        echo "Unstowing $pkg..."
        stow -v --target="$HOME" --delete "$pkg"
    else
        echo "Warning: package '$pkg' not found"
    fi
done
