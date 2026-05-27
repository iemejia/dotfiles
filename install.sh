#!/usr/bin/env bash

DOTFILES=~/repositories/dotfiles

# install sub-scripts
"$DOTFILES/install-minimal.sh"
"$DOTFILES/install-dev.sh"
"$DOTFILES/install-linux.sh"

mkdir -p ~/.config/nvim
ln -sfv "$DOTFILES/.config/nvim/init.lua" ~/.config/nvim/
mkdir -p ~/.config/ghostty
ln -sfv "$DOTFILES/.config/ghostty/config" ~/.config/ghostty/
ln -sfv "$DOTFILES/.emacs.d" ~/.emacs.d
ln -sfv "$DOTFILES/.irssi" ~/.irssi
ln -sfv "$DOTFILES/.oh-my-zsh" ~/.oh-my-zsh
ln -sfv "$DOTFILES/.zsh-autosuggestions" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -sfv "$DOTFILES/.zsh-syntax-highlighting" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -sfv "$DOTFILES/s3.exclude" ~/s3.exclude

# optional: requires Dropbox
if [ -d ~/Dropbox/Documents ]; then
    ln -sfv ~/Dropbox/Documents/research-notes ~/research-notes
fi

~/.bash_it/install.sh
