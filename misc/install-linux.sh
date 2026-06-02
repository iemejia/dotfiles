#!/usr/bin/env bash

DOTFILES=~/repositories/dotfiles

ln -sfv "$DOTFILES/.xinitrc" ~/.xinitrc
ln -sfv "$DOTFILES/.fonts" ~/.fonts
ln -sfv "$DOTFILES/.mplayer" ~/.mplayer
ln -sfv "$DOTFILES/.mpv" ~/.mpv

mkdir -p ~/.config/fontconfig/conf.d
ln -sfv "$DOTFILES/.config/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf
ln -sfv "$DOTFILES/.config/fontconfig/conf.d/10-powerline-symbols.conf" ~/.config/fontconfig/conf.d/10-powerline-symbols.conf

fc-cache -vf ~/.fonts
