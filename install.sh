#!/usr/bin/env bash
# Install dotfiles using GNU Stow
# Usage: ./install.sh [package...]
#   With no arguments, installs all packages.

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

# Ensure stow is available
if ! command -v stow &>/dev/null; then
    echo "Error: GNU Stow is not installed."
    echo "  Ubuntu/Debian: sudo apt install stow"
    echo "  macOS:         brew install stow"
    exit 1
fi

# Initialize submodules if needed
git submodule update --init --recursive

# All stow packages (order doesn't matter)
ALL_PACKAGES=(
    bash
    zsh
    git
    vim
    tmux
    fish
    ghostty
    nvim
    emacs
    python
    node
    java
    media
    fonts
    tools
    copilot
    scripts
)

if [ $# -gt 0 ]; then
    PACKAGES=("$@")
else
    PACKAGES=("${ALL_PACKAGES[@]}")
fi

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo "Stowing $pkg..."
        stow -v --target="$HOME" "$pkg"
    else
        echo "Warning: package '$pkg' not found, skipping"
    fi
done

