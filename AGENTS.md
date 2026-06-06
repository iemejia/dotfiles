# AGENTS.md

## Repository overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors `$HOME`.

## Structure

```
<package>/<path-relative-to-home>
```

For example, `bash/.bashrc` becomes `~/.bashrc` when stowed.

### Packages

- `bash/` — Bash shell config
- `zsh/` — Zsh + oh-my-zsh + plugins (submodules)
- `git/` — Git config and global ignore
- `vim/` — Vim config (native packages, no plugin manager at runtime)
- `emacs/` — Emacs config (optional package)
- `tmux/` — tmux config
- `fish/` — Fish shell config
- `ghostty/` — Ghostty terminal config
- `nvim/` — Neovim config (minimal)
- `python/` — pip config
- `node/` — npm config
- `java/` — Maven and Gradle settings
- `media/` — mpv, mplayer configs
- `copilot/` — GitHub Copilot CLI config (settings, LSP, MCP, instructions)
- `tools/` — fzf, irssi, psql, gdb, opencode, subversion, fontconfig
- `fonts/` — Powerline font symbols
- `scripts/` — Utility scripts installed to ~/.local/bin/

### Non-stow files at root

- `install.sh` / `uninstall.sh` — Stow/unstow packages
- `misc/` — Reference configs (cloud-init, s3 exclude, backups, streaming, Firefox privacy script)

## Conventions

- Cross-platform: configs must work on both macOS and Linux
- Platform-specific code uses guards (`uname`, `[ -d ... ]`, `command -v`)
- Submodules: oh-my-zsh, fzf, zsh-autosuggestions, zsh-syntax-highlighting
- Vim plugins are cloned via `scripts/.local/bin/install-vim-plugins.sh` into `~/.vim/pack/plugins/start/`
- Shell env vars and PATH setup live in `bash/.profile` (sourced by zsh via `.zshrc`)

## Making changes

1. Edit files in the package directory (e.g., `vim/.vimrc`)
2. Changes take effect immediately (stow creates symlinks)
3. To add a new dotfile: place it at the correct path inside a package, then re-stow
4. To add a new package: create a directory, add files mirroring `$HOME`, update `install.sh`
