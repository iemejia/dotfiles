#!/usr/bin/env bash
# Uninstall (unstow) dotfile packages
# Usage: ./uninstall.sh [package...]
#   With no arguments, uninstalls all packages.

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

# All stow packages (mirrors install.sh)
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

# Packages with large submodules that need directory folding (no --no-folding)
FOLDED_PACKAGES=(zsh)

is_folded_pkg() {
    local pkg="$1"
    for p in "${FOLDED_PACKAGES[@]}"; do
        [ "$p" = "$pkg" ] && return 0
    done
    return 1
}

uninstall_ssh() {
    echo "Removing ssh config symlink..."
    rm -fv ~/.ssh/config
    # Remove config.d only if empty (preserve user-created host files)
    rmdir ~/.ssh/config.d 2>/dev/null && echo "Removed empty ~/.ssh/config.d/" || true
}

if [ $# -gt 0 ]; then
    for arg in "$@"; do
        if [ "$arg" = "ssh" ]; then
            uninstall_ssh
        fi
    done
else
    uninstall_ssh
fi

for pkg in "${PACKAGES[@]}"; do
    [ "$pkg" = "ssh" ] && continue
    if [ -d "$pkg" ]; then
        echo "Unstowing $pkg..."
        if is_folded_pkg "$pkg"; then
            stow -v --target="$HOME" --delete "$pkg"
        else
            # Handle both old-style (folded) and new-style (no-folding) symlinks
            stow --target="$HOME" --delete "$pkg" 2>/dev/null || true
            stow -v --no-folding --target="$HOME" --delete "$pkg" 2>/dev/null || true
        fi
    else
        echo "Warning: package '$pkg' not found"
    fi
done
