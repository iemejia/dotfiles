# dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/iemejia/dotfiles ~/repositories/dotfiles
cd ~/repositories/dotfiles

# Install stow
brew install stow        # macOS
sudo apt install stow    # Debian/Ubuntu

# Stow all packages
./install.sh

# Or stow only what you need (e.g., on a server)
./install.sh bash git vim tmux scripts
```

If you already cloned without `--recurse-submodules`, run:

```bash
git submodule update --init --recursive
```

## How it works

Each top-level directory is a stow package that mirrors `$HOME`. For example:

```
bash/.bashrc        ->  ~/.bashrc
nvim/.config/nvim/  ->  ~/.config/nvim/
scripts/.local/bin/ ->  ~/.local/bin/
```

Running `stow <package>` from the repo root creates symlinks in `$HOME` pointing back into the repo. Edits to the files take effect immediately.

## Packages

| Package | Contents |
|---------|----------|
| `bash` | .bashrc, .bash_aliases, .bash_profile, .bash_logout, .profile, .inputrc |
| `zsh` | .zshrc, .zshenv, .zprofile, oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting |
| `git` | .gitconfig, .config/git/ignore, commit message template |
| `vim` | .vimrc, .gvimrc, .vim/ |
| `emacs` | .emacs.d/ |
| `tmux` | .tmux.conf, .tmuxline.theme |
| `fish` | .config/fish/ (config, env, aliases, functions) |
| `ghostty` | .config/ghostty/ |
| `nvim` | .config/nvim/init.lua |
| `python` | .pip/pip.conf |
| `node` | .npmrc |
| `java` | .m2/settings.xml, .gradle/gradle.properties |
| `media` | .mpv/, .mplayer/ |
| `tools` | .fzf, .irssi, .psqlrc, .gdbinit, .latexmkrc, .wgetrc, .vale.ini, .subversion, .config/opencode, .config/fontconfig, .config/gtk-3.0 |
| `fonts` | .fonts/ (PowerlineSymbols) |
| `scripts` | .local/bin/ (update-\*, git-\*, tmuxsession, clean-nvidia) |

## Uninstalling

```bash
./uninstall.sh bash git   # Remove specific packages
./uninstall.sh            # Show available packages
```

## Adding a new dotfile

1. Place the file at the correct path inside a package directory (mirroring `$HOME`)
2. Re-stow the package: `stow <package>` from the repo root

## Scripts (~/.local/bin/)

| Script | Description |
|--------|-------------|
| `update-weekly.sh` | Runs all update scripts (env + OS + repositories) |
| `update-env.sh` | Updates oh-my-zsh, vim packages, virtualenvs |
| `update-mac.sh` | brew update, upgrade, cleanup |
| `update-linux.sh` | apt update, full-upgrade, autoclean, autoremove |
| `update-docker.sh` | Prunes docker images and containers |
| `update-repositories.sh` | Fetches/pulls all git repos across workspace directories |
| `git-status-all.sh` | Reports uncommitted, unpushed, or diverged repos |
| `git-cherry-picker.sh` | Cherry-pick discovery between branches |
| `git-classify-repos.sh` | Classifies repos as public/private via gh CLI |
| `git-migrate-to-sha256.sh` | Migrates a git repo from SHA-1 to SHA-256 |
| `clean-nvidia.sh` | Cleans up old NVIDIA driver packages |
| `tmuxsession.sh` | Creates a tmux grid session with configurable panes |

## Misc

Reference configs and one-off setup scripts (not stow-managed):

- `misc/install-linux.sh` — Base Linux package setup
- `misc/rust-install.sh` — Installs Rust CLI tools (bat, eza, fd, ripgrep, etc.)
- `misc/cloud-init.yml` — Cloud-init template for new VMs
- `misc/s3.exclude` — S3 sync exclude patterns
- `misc/make-firefox-private-again.com.sh` — Firefox privacy hardening
- `misc/backups/` — Backup config references
- `misc/streaming/` — Streaming setup references
