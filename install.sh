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

# Packages with large submodules that need directory folding (no --no-folding)
FOLDED_PACKAGES=(zsh)

# All stow packages (order doesn't matter)
ALL_PACKAGES=(
    bash
    zsh
    git
    gnupg
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

# SSH is handled separately (stow can't manage ~/.ssh without risking auth keys)
install_ssh() {
    echo "Installing ssh config..."
    mkdir -p ~/.ssh/sockets ~/.ssh/config.d && chmod 700 ~/.ssh
    ln -sfv "$DOTFILES/ssh/.ssh/config" ~/.ssh/config
    for f in "$DOTFILES"/ssh/.ssh/config.d/*.conf; do
        [ -e "$f" ] || continue
        ln -sfv "$f" ~/.ssh/config.d/"$(basename "$f")"
    done
}

# VS Code config path differs by OS (can't use stow)
install_vscode() {
    echo "Installing vscode config..."
    case "$(uname -s)" in
        Darwin) VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User" ;;
        *)      VSCODE_USER_DIR="$HOME/.config/Code/User" ;;
    esac
    mkdir -p "$VSCODE_USER_DIR"
    for f in "$DOTFILES"/vscode/*; do
        ln -sfv "$f" "$VSCODE_USER_DIR/$(basename "$f")"
    done
}

if [ $# -gt 0 ]; then
    # If ssh or vscode was requested explicitly, handle it
    for arg in "$@"; do
        if [ "$arg" = "ssh" ]; then
            install_ssh
        elif [ "$arg" = "vscode" ]; then
            install_vscode
        fi
    done
else
    install_ssh
    install_vscode
fi

is_folded_pkg() {
    local pkg="$1"
    for p in "${FOLDED_PACKAGES[@]}"; do
        [ "$p" = "$pkg" ] && return 0
    done
    return 1
}

# Remove empty directories left behind by a previous --no-folding uninstall,
# so that stow can fold them into directory-level symlinks.
cleanup_empty_dirs() {
    local pkg="$1"
    (cd "$pkg" && find . -type d) | sort -r | while read -r dir; do
        dir="${dir#./}"
        [ "$dir" = "." ] && continue
        target="$HOME/$dir"
        if [ -d "$target" ] && [ ! -L "$target" ] && [ -z "$(ls -A "$target")" ]; then
            rmdir "$target" 2>/dev/null || true
        fi
    done
}

for pkg in "${PACKAGES[@]}"; do
    [ "$pkg" = "ssh" ] && continue
    [ "$pkg" = "vscode" ] && continue
    if [ -d "$pkg" ]; then
        echo "Stowing $pkg..."
        if is_folded_pkg "$pkg"; then
            # Clean up any prior state (both old and --no-folding styles)
            stow --target="$HOME" --delete "$pkg" 2>/dev/null || true
            stow --no-folding --target="$HOME" --delete "$pkg" 2>/dev/null || true
            cleanup_empty_dirs "$pkg"
            stow -v --target="$HOME" "$pkg"
        else
            # Clean up any old-style folded symlinks (from before --no-folding migration)
            stow --target="$HOME" --delete "$pkg" 2>/dev/null || true
            stow -v --no-folding --target="$HOME" "$pkg"
        fi
    else
        echo "Warning: package '$pkg' not found, skipping"
    fi
done

# Create oh-my-zsh custom plugin symlinks (can't live in the submodule)
for arg in "${PACKAGES[@]}"; do
    if [ "$arg" = "zsh" ]; then
        echo "Linking zsh plugin symlinks..."
        ln -sfn "$HOME/.zsh-autosuggestions" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
        ln -sfn "$HOME/.zsh-syntax-highlighting" "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
        break
    fi
done

