#!/usr/bin/env bash

DOTFILES=~/repositories/dotfiles

ln -sfv "$DOTFILES/.bash_aliases" ~/.bash_aliases
ln -sfv "$DOTFILES/.bash_profile" ~/.bash_profile
ln -sfv "$DOTFILES/.bashrc" ~/.bashrc
ln -sfv "$DOTFILES/.profile" ~/.profile

mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions
ln -sfv "$DOTFILES/.config/fish/config.fish" ~/.config/fish/
ln -sfv "$DOTFILES/.config/fish/conf.d/env.fish" ~/.config/fish/conf.d/
ln -sfv "$DOTFILES/.config/fish/conf.d/aliases.fish" ~/.config/fish/conf.d/
for f in "$DOTFILES"/.config/fish/functions/*.fish; do
    ln -sfv "$f" ~/.config/fish/functions/
done

ln -sfv "$DOTFILES/.inputrc" ~/.inputrc
ln -sfv "$DOTFILES/.git-completion.bash" ~/.git-completion.bash
ln -sfv "$DOTFILES/.git_commit_msg.txt" ~/.git_commit_msg.txt
ln -sfv "$DOTFILES/.gitconfig" ~/.gitconfig
mkdir -p ~/.config/git
ln -sfv "$DOTFILES/.gitignore.global" ~/.config/git/ignore
ln -sfv "$DOTFILES/.tmux.conf" ~/.tmux.conf
ln -sfv "$DOTFILES/.vim" ~/.vim
ln -sfv "$DOTFILES/.vimrc" ~/.vimrc

# subversion
mkdir -p ~/.subversion
ln -sfv "$DOTFILES/.subversion/servers" ~/.subversion/servers

mkdir -p ~/.m2
ln -sfv "$DOTFILES/.m2/settings.xml" ~/.m2/settings.xml

mkdir -p ~/.gradle
ln -sfv "$DOTFILES/.gradle/gradle.properties" ~/.gradle/gradle.properties

