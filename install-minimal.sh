#!/usr/bin/env bash

ln -sfv ~/repositories/dotfiles/.bash_aliases ~/.bash_aliases
ln -sfv ~/repositories/dotfiles/.bash_profile ~/.bash_profile
ln -sfv ~/repositories/dotfiles/.bashrc ~/.bashrc
ln -sfv ~/repositories/dotfiles/.profile ~/.profile

mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions
ln -sfv ~/repositories/dotfiles/.config/fish/config.fish ~/.config/fish/
ln -sfv ~/repositories/dotfiles/.config/fish/conf.d/env.fish ~/.config/fish/conf.d/
ln -sfv ~/repositories/dotfiles/.config/fish/conf.d/aliases.fish ~/.config/fish/conf.d/
for f in ~/repositories/dotfiles/.config/fish/functions/*.fish; do
    ln -sfv "$f" ~/.config/fish/functions/
done

ln -sfv ~/repositories/dotfiles/.git_commit_msg.txt ~/.git_commit_msg.txt
ln -sfv ~/repositories/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/repositories/dotfiles/.tmux.conf ~/.tmux.conf
ln -sfv ~/repositories/dotfiles/.vim ~/.vim
ln -sfv ~/repositories/dotfiles/.vimrc ~/.vimrc

# subversion
mkdir -p ~/.subversion
ln -sfv ~/repositories/dotfiles/.subversion/servers ~/.subversion/servers

mkdir -p ~/.m2
ln -sfv ~/repositories/dotfiles/.m2/settings.xml ~/.m2/settings.xml

mkdir -p ~/.gradle
ln -sfv ~/repositories/dotfiles/.gradle/gradle.properties ~/.gradle/gradle.properties

