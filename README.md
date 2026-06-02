dotfiles
========

A repo to keep a copy of my dotfiles

## Scripts

| Script | Description |
|--------|-------------|
| `install.sh` | Runs sub-install scripts and symlinks dotfiles (nvim, ghostty, emacs, irssi, etc.) into the home directory |
| `install-dev.sh` | Symlinks development/update scripts and config files into `~/.local/bin` and `~/.config` |
| `install-linux.sh` | Symlinks Linux-specific dotfiles (xinitrc, fonts, mplayer, mpv) and rebuilds the font cache |
| `rust-install.sh` | Installs a set of Rust CLI tools (bat, ripgrep, fd, exa, etc.) via cargo |
| `update-mac.sh` | Runs brew update, upgrade, and cleanup on macOS |
| `update-linux.sh` | Runs apt update, full-upgrade, autoclean, and autoremove on Debian/Ubuntu |
| `update-env.sh` | Updates oh-my-zsh, vim bundles, and virtualenvs by pulling latest changes |
| `update-repositories.sh` | Fetches and pulls all git/svn repositories across multiple workspace directories, reporting what changed |
| `git-status-all.sh` | Scans subdirectories for uncommitted, unpushed, or diverged repos and reports what needs attention |
| `git-cherry-picker.sh` | Discovers and applies cherry-picks between two branches (list, analyze, or apply modes) |
| `git-classify-repos.sh` | Scans subdirectories and classifies repos as public/private using the `gh` CLI |
| `git-migrate-to-sha256.sh` | Migrates a Git repository from SHA-1 to SHA-256 object format |
| `tmuxsession.sh` | Creates a tmux grid of configurable columns x rows panes in a session/window |
| `clean-nvidia.sh` | Clears NVIDIA shader caches and resets GPU state to fix stutters on Quadro M1200 |
| `make-firefox-private-again.com.sh` | Disables Firefox's privacy-preserving attribution (ad tracking) via user.js |