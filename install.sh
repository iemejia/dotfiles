#!/usr/bin/env bash

#pip install --user powerline-status

ln -sfv ~/repositories/dotfiles/.bash_profile ~/.bash_profile
ln -sfv ~/repositories/dotfiles/.bash_logout ~/.bash_logout
ln -sfv ~/repositories/dotfiles/.bashrc ~/.bashrc
ln -sfv ~/repositories/dotfiles/.emacs.d ~/.emacs.d
ln -sfv ~/repositories/dotfiles/.gdbinit ~/.gdbinit
ln -sfv ~/repositories/dotfiles/.git-completion.bash ~/.git-completion.bash
ln -sfv ~/repositories/dotfiles/.git-prompt.sh ~/.git-prompt.sh
ln -sfv ~/repositories/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/repositories/dotfiles/.inputrc ~/.inputrc
ln -sfv ~/repositories/dotfiles/.irssi ~/.irssi
ln -sfv ~/repositories/dotfiles/.latexmkrc ~/.latexmkrc
ln -sfv ~/repositories/dotfiles/.profile ~/.profile
ln -sfv ~/repositories/dotfiles/.screenrc ~/.screenrc
ln -sfv ~/repositories/dotfiles/.tmux.conf ~/.tmux.conf
ln -sfv ~/repositories/dotfiles/.vim ~/.vim
ln -sfv ~/repositories/dotfiles/.vimrc ~/.vimrc
ln -sfv ~/repositories/dotfiles/.gvimrc ~/.gvimrc
ln -sfv ~/repositories/dotfiles/.zprofile ~/.zprofile
ln -sfv ~/repositories/dotfiles/.zshrc ~/.zshrc
ln -sfv ~/repositories/dotfiles/.zshenv ~/.zshenv
ln -sfv ~/repositories/dotfiles/.oh-my-zsh ~/.oh-my-zsh
ln -sfv ~/repositories/dotfiles/.bash_it ~/.bash_it
ln -sfv ~/repositories/dotfiles/.xinitrc ~/.xinitrc
#cp -R ~/repositories/dotfiles/.fonts/* ~/.fonts/
#ln -sfv ~/Dropbox/static-resources/fonts/ .fonts
ln -sfv ~/repositories/dotfiles/.fonts ~/.fonts
ln -sfv ~/repositories/dotfiles/.fonts.conf  ~/.fonts.conf
ln -sfv ~/repositories/dotfiles/.fonts.conf.d  ~/.fonts.conf.d
ln -sfv ~/repositories/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0
ln -sfv ~/repositories/dotfiles/s3.exclude ~/s3.exclude
ln -sfv ~/repositories/dotfiles/.mplayer ~/.mplayer
ln -sfv ~/Dropbox/Documents/research-notes ~/research-notes
ln -s ~/repositories/dotfiles/.git_commit_msg.txt ~/.git_commit_msg.txt
ln -sfv ~/repositories/dotfiles/.hiverc ~/.hiverc
ln -sfv ~/repositories/dotfiles/.npmrc ~/.npmrc
ln -sfv ~/repositories/dotfiles/update.sh ~/.local/bin/update.sh
ln -sfv ~/repositories/dotfiles/update-weekly.sh ~/.local/bin/update-weekly.sh

fc-cache -vf ~/.fonts
~/.bash_it/install.sh

