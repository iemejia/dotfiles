# dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

```bash
# Clone
git clone https://github.com/iemejia/dotfiles ~/repositories/dotfiles
cd ~/repositories/dotfiles

# Install stow
brew install stow        # macOS
sudo apt install stow    # Debian/Ubuntu

# Stow all packages
./install.sh

# Or stow only what you need (e.g., on a server)
./install.sh bash git vim tmux scripts
```

## Packages

| Package | Contents |
|---------|----------|
| `bash` | .bashrc, .bash_aliases, .bash_profile, .profile, .inputrc |
| `zsh` | .zshrc, .zshenv, .zprofile, oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting |
| `git` | .gitconfig, .config/git/ignore, commit template |
| `vim` | .vimrc, .gvimrc, .vim/ |
| `emacs` | .emacs.d/ (optional, install with `./install.sh emacs`) |
| `tmux` | .tmux.conf, tmuxline theme |
| `fish` | .config/fish/ (config, env, aliases, functions) |
| `ghostty` | .config/ghostty/ |
| `nvim` | .config/nvim/ |
| `python` | .pip/pip.conf |
| `node` | .npmrc |
| `java` | .m2/settings.xml, .gradle/gradle.properties |
| `media` | .mpv/, .mplayer/ |
| `tools` | .fzf, .irssi, .psqlrc, .gdbinit, .latexmkrc, .subversion, opencode |
| `fonts` | .fonts/ (PowerlineSymbols) |
| `scripts` | .local/bin/ (update-*, git-*, install-vim-plugins, etc.) |

## Uninstalling

```bash
./uninstall.sh emacs    # Remove a package's symlinks
./uninstall.sh          # Show available packages
```

## Vim plugins

Vim uses native packages (vim 8+). Install/update plugins with:

```bash
~/.local/bin/install-vim-plugins.sh
```

## Scripts

| Script | Description |
|--------|-------------|
| `install-vim-plugins.sh` | Clones/updates vim plugins into ~/.vim/pack/plugins/start/ |
| `rust-install.sh` | Installs Rust CLI tools (bat, eza, fd, ripgrep, etc.) via cargo |
| `update-mac.sh` | brew update, upgrade, cleanup |
| `update-linux.sh` | apt update, full-upgrade, autoclean, autoremove |
| `update-env.sh` | Updates oh-my-zsh, vim packages, virtualenvs |
| `update-weekly.sh` | Runs all update scripts (env + OS + repositories) |
| `update-repositories.sh` | Fetches/pulls all git repos across workspace directories |
| `git-status-all.sh` | Reports uncommitted, unpushed, or diverged repos |
| `git-cherry-picker.sh` | Cherry-pick discovery between branches |
| `git-classify-repos.sh` | Classifies repos as public/private via gh CLI |
| `tmuxsession.sh` | Creates a tmux grid session with configurable panes |
