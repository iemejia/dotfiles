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
| `copilot` | .copilot/ (settings, LSP servers, MCP servers, custom instructions) |
| `tools` | .fzf, .irssi, .psqlrc, .gdbinit, .latexmkrc, .wgetrc, .vale.ini, .subversion, .config/opencode, .config/fontconfig, .config/gtk-3.0 |
| `fonts` | .fonts/ (PowerlineSymbols) |
| `scripts` | .local/bin/ (update-\*, git-\*, tmuxsession, clean-nvidia) |

## Updating

After pulling new changes (`git pull`), symlinks already point to the updated files so most changes take effect immediately. However, there are cases where you need to re-stow:

### When to re-stow

Re-stow a package when files were **added or removed** (not just edited):

```bash
# Re-stow a single package (removes stale links, creates new ones)
stow -R <package>

# Re-stow everything
./install.sh
```

### Adopting existing files

If a target file already exists (e.g., a tool created a default config before you stowed), use `--adopt` to pull it into the repo and replace it with a symlink:

```bash
stow --adopt <package>
# Then review what changed in git
git diff
```

This is common with tools that auto-generate config on first run (e.g., `~/.copilot/settings.json`, `~/.config/opencode/`). After adopting, update the file in the repo to your preferred version and commit.

### Handling conflicts

If stow reports a conflict:

```
WARNING! stowing <pkg> would cause conflicts:
  * cannot stow ... over existing target ... since neither a link nor a directory
```

You have three options:

1. **Adopt and review**: `stow --adopt <package>` then `git diff` to see what was pulled in
2. **Remove the conflicting file**: `rm ~/.<conflicting-file>` then re-stow
3. **Back up first**: `mv ~/.<file> ~/.<file>.bak` then re-stow

### Packages with mixed ownership

Some packages stow into directories that also contain auto-managed files (e.g., `copilot/.copilot/` coexists with Copilot CLI's `config.json`, `session-state/`, `logs/`). Stow handles this correctly by creating individual symlinks inside the existing directory rather than symlinking the whole directory.

### Submodule updates

After `git pull`, if submodules were updated:

```bash
git submodule update --init --recursive
```

## Uninstalling

```bash
./uninstall.sh bash git   # Remove specific packages
./uninstall.sh            # Show available packages
```

## Adding a new dotfile

1. Place the file at the correct path inside a package directory (mirroring `$HOME`)
2. Re-stow the package: `stow -R <package>` from the repo root

## Adding a new package

1. Create a directory at the repo root (e.g., `myapp/`)
2. Inside it, mirror the `$HOME` path structure (e.g., `myapp/.config/myapp/config.toml`)
3. Add the package name to `install.sh`
4. Stow it: `stow myapp`

## Scripts (~/.local/bin/)

| Script | Description |
|--------|-------------|
| `update-weekly.sh` | Runs all update scripts (env + OS + repositories) |
| `update-env.sh` | Updates oh-my-zsh, vim packages, virtualenvs |
| `update-mac.sh` | brew update, upgrade, cleanup |
| `update-linux.sh` | apt update, full-upgrade, autoclean, autoremove |
| `update-docker.sh` | Prunes docker images and containers |
| `update-fabio.sh` | Updates Fabio load balancer |
| `update-repositories.sh` | Fetches/pulls all git repos across workspace directories |
| `git-amend-commits.sh` | Adds Assisted-by trailers and optionally changes commit author |
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
