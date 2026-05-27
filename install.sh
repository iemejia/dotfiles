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
ln -sfv "$DOTFILES/.gdbinit" ~/.gdbinit
ln -sfv "$DOTFILES/.psqlrc" ~/.psqlrc
ln -sfv "$DOTFILES/.irssi" ~/.irssi
ln -sfv "$DOTFILES/.latexmkrc" ~/.latexmkrc
ln -sfv "$DOTFILES/.screenrc" ~/.screenrc
ln -sfv "$DOTFILES/.gvimrc" ~/.gvimrc
ln -sfv "$DOTFILES/.zprofile" ~/.zprofile
ln -sfv "$DOTFILES/.zshrc" ~/.zshrc
ln -sfv "$DOTFILES/.zshenv" ~/.zshenv
ln -sfv "$DOTFILES/.oh-my-zsh" ~/.oh-my-zsh
ln -sfv "$DOTFILES/.zsh-autosuggestions" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -sfv "$DOTFILES/.zsh-syntax-highlighting" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -sfv "$DOTFILES/.bash_it" ~/.bash_it
ln -sfv "$DOTFILES/.hiverc" ~/.hiverc
ln -sfv "$DOTFILES/s3.exclude" ~/s3.exclude

# tmux plugins
mkdir -p ~/.tmux/plugins
ln -sfv "$DOTFILES/.tpm" ~/.tmux/plugins/tpm
ln -sfv "$DOTFILES/.tmuxline.theme" ~/.tmuxline.theme

# note you must run tmux and then do C-a I
ln -sfv "$DOTFILES/.config/base16-shell" ~/.config/base16-shell

# system aliases
ln -sfv /usr/share/vim/vim80/macros/less.sh ~/.local/bin/vless

# optional: requires Dropbox
if [ -d ~/Dropbox/Documents ]; then
    ln -sfv ~/Dropbox/Documents/research-notes ~/research-notes
fi

~/.bash_it/install.sh
