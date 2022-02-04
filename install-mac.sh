#!/usr/bin/env bash

ln -sfv ~/repositories/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/repositories/dotfiles/.git_commit_msg.txt ~/.git_commit_msg.txt
ln -sfv ~/repositories/dotfiles/.profile ~/.profile
ln -sfv ~/repositories/dotfiles/.oh-my-zsh ~/.oh-my-zsh
ln -sfv ~/repositories/dotfiles/.zshrc ~/.zshrc
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

mkdir -p ~/.pip
ln -sfv ~/repositories/dotfiles/.pip/pip.conf ~/.pip/pip.conf
ln -sfv ~/repositories/dotfiles/.theanorc ~/.theanorc
ln -sfv ~/repositories/dotfiles/.keras ~/.keras

# sdkman configuration
mkdir -p ~/.sdkman/etc/config
ln -sfv ~/repositories/dotfiles/.sdkmanconfig ~/.sdkman/etc/config

# alacritty
mkdir -p ~/.config/alacritty
ln -sfv ~/repositories/dotfiles/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

# Install fonts
#~/repositories/dotfiles/.fonts/powerline-fonts/install.sh
