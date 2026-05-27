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

