#!/usr/bin/env bash

DOTFILES=~/repositories/dotfiles

# install minimal and dev scripts
"$DOTFILES/install-minimal.sh"
"$DOTFILES/install-dev.sh"

mkdir -p ~/.config/nvim
ln -sfv "$DOTFILES/.config/nvim/init.lua" ~/.config/nvim/
mkdir -p ~/.config/ghostty
ln -sfv "$DOTFILES/.config/ghostty/config" ~/.config/ghostty/
ln -sfv "$DOTFILES/.emacs.d" ~/.emacs.d
ln -sfv "$DOTFILES/.gdbinit" ~/.gdbinit
ln -sfv "$DOTFILES/.git-completion.bash" ~/.git-completion.bash
ln -sfv "$DOTFILES/.gitignore.global" ~/.config/git/ignore
ln -sfv "$DOTFILES/.inputrc" ~/.inputrc
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
ln -sfv "$DOTFILES/.xinitrc" ~/.xinitrc
ln -sfv "$DOTFILES/.fonts" ~/.fonts
ln -sfv "$DOTFILES/.fonts.conf" ~/.fonts.conf
ln -sfv "$DOTFILES/.fonts.conf.d" ~/.fonts.conf.d
ln -sfv "$DOTFILES/.gtkrc-2.0" ~/.gtkrc-2.0
ln -sfv "$DOTFILES/s3.exclude" ~/s3.exclude
ln -sfv "$DOTFILES/.mplayer" ~/.mplayer
ln -sfv "$DOTFILES/.mpv" ~/.mpv
ln -sfv ~/Dropbox/Documents/research-notes ~/research-notes
ln -sfv "$DOTFILES/.hiverc" ~/.hiverc
ln -sfv "$DOTFILES/.npmrc" ~/.npmrc

# tmux plugins
mkdir -p ~/.tmux/plugins
ln -sfv "$DOTFILES/.tpm" ~/.tmux/plugins/tpm
ln -sfv "$DOTFILES/.tmuxline.theme" ~/.tmuxline.theme

# note you must run tmux and then do C-a I
ln -sfv "$DOTFILES/.config/base16-shell" ~/.config/base16-shell
ln -sfv "$DOTFILES/.fzf" ~/.fzf
ln -sfv "$DOTFILES/.gradle-completion" ~/.gradle-completion

# system aliases
ln -sfv /usr/share/vim/vim80/macros/less.sh ~/.local/bin/vless

mkdir -p ~/.pip
ln -sfv "$DOTFILES/.pip/pip.conf" ~/.pip/pip.conf

/usr/bin/yarn config set prefix ~/.node --global

# asdf defaults
ln -sfv "$DOTFILES/.tool-versions" ~/.tool-versions

fc-cache -vf ~/.fonts
~/.bash_it/install.sh
