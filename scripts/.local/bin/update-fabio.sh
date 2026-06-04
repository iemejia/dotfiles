#!/usr/bin/env bash
set -euo pipefail

# Update fabio CLI to the latest release from github.com/iemejia/fabio
# Supports macOS (arm64/x64) and Linux (arm64/x64)

REPO="iemejia/fabio"
INSTALL_DIR="${FABIO_INSTALL_DIR:-$HOME/.local/bin}"
BINARY_NAME="fabio"
TMP_DIR=""

cleanup() { [ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# Detect platform and architecture
detect_platform() {
  local os arch
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "$os" in
    darwin) os="macos" ;;
    linux)  os="linux" ;;
    *)      echo "Error: Unsupported OS: $os" >&2; exit 1 ;;
  esac

  case "$arch" in
    x86_64|amd64) arch="x64" ;;
    arm64|aarch64) arch="arm64" ;;
    *)             echo "Error: Unsupported architecture: $arch" >&2; exit 1 ;;
  esac

  echo "${os}-${arch}"
}

# Get the latest release tag from GitHub API
get_latest_version() {
  local url="https://api.github.com/repos/${REPO}/releases/latest"
  curl -fsSL "$url" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/'
}

# Get current installed version
get_current_version() {
  if command -v "$INSTALL_DIR/$BINARY_NAME" &>/dev/null; then
    "$INSTALL_DIR/$BINARY_NAME" --version 2>/dev/null | awk '{print $NF}' || echo "unknown"
  elif command -v "$BINARY_NAME" &>/dev/null; then
    "$BINARY_NAME" --version 2>/dev/null | awk '{print $NF}' || echo "unknown"
  else
    echo "not installed"
  fi
}

main() {
  echo "==> Detecting platform..."
  local platform
  platform="$(detect_platform)"
  echo "    Platform: $platform"

  echo "==> Checking latest release..."
  local latest_version
  latest_version="$(get_latest_version)"
  echo "    Latest: $latest_version"

  local current_version
  current_version="$(get_current_version)"
  echo "    Current: $current_version"

  # Strip 'v' prefix for comparison
  local latest_clean="${latest_version#v}"
  if [ "$current_version" = "$latest_clean" ]; then
    echo "==> Already up to date ($current_version). Nothing to do."
    exit 0
  fi

  # Determine asset name and download URL
  local asset_name="fabio-${platform}.tar.gz"
  local sha_name="${asset_name}.sha256"
  local base_url="https://github.com/${REPO}/releases/download/${latest_version}"
  local download_url="${base_url}/${asset_name}"
  local sha_url="${base_url}/${sha_name}"

  # Create temp directory
  TMP_DIR="$(mktemp -d)"

  echo "==> Downloading $asset_name..."
  curl -fsSL -o "$TMP_DIR/$asset_name" "$download_url"

  echo "==> Downloading checksum..."
  curl -fsSL -o "$TMP_DIR/$sha_name" "$sha_url"

  echo "==> Verifying checksum..."
  (
    cd "$TMP_DIR"
    if command -v shasum &>/dev/null; then
      shasum -a 256 -c "$sha_name"
    elif command -v sha256sum &>/dev/null; then
      sha256sum -c "$sha_name"
    else
      echo "    Warning: No sha256 tool found, skipping verification" >&2
    fi
  )

  echo "==> Extracting..."
  tar -xzf "$TMP_DIR/$asset_name" -C "$TMP_DIR"

  echo "==> Installing to $INSTALL_DIR/$BINARY_NAME..."
  mkdir -p "$INSTALL_DIR"
  mv "$TMP_DIR/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
  chmod +x "$INSTALL_DIR/$BINARY_NAME"

  echo "==> Done! Updated fabio: $current_version -> $latest_clean"
  "$INSTALL_DIR/$BINARY_NAME" --version
}

main "$@"
