#!/usr/bin/env bash

DOTFILES=~/repositories/dotfiles

mkdir -p ~/.local/bin

ln -sfv "$DOTFILES/update-docker.sh" ~/.local/bin/update-docker.sh
ln -sfv "$DOTFILES/update-env.sh" ~/.local/bin/update-env.sh
ln -sfv "$DOTFILES/update-linux.sh" ~/.local/bin/update-linux.sh
ln -sfv "$DOTFILES/update-mac.sh" ~/.local/bin/update-mac.sh
ln -sfv "$DOTFILES/update-repositories.sh" ~/.local/bin/update-repositories.sh
ln -sfv "$DOTFILES/update-weekly.sh" ~/.local/bin/update-weekly.sh

ln -sfv "$DOTFILES/.config/opencode/opencode.json" ~/.config/opencode/opencode.json

ln -sfv "$DOTFILES/.fzf" ~/.fzf
ln -sfv "$DOTFILES/.npmrc" ~/.npmrc
ln -sfv "$DOTFILES/.gdbinit" ~/.gdbinit
ln -sfv "$DOTFILES/.psqlrc" ~/.psqlrc
ln -sfv "$DOTFILES/.latexmkrc" ~/.latexmkrc


# system aliases
VIM_LESS=$(find /usr/share/vim -name less.sh 2>/dev/null | head -1)
[ -n "$VIM_LESS" ] && ln -sfv "$VIM_LESS" ~/.local/bin/vless

mkdir -p ~/.pip
ln -sfv "$DOTFILES/.pip/pip.conf" ~/.pip/pip.conf

if command -v yarn > /dev/null 2>&1; then
    yarn config set prefix ~/.node --global
fi

