#!/usr/bin/env bash

DOTFILES=~/repositories/dotfiles

ln -sfv "$DOTFILES/.xinitrc" ~/.xinitrc
ln -sfv "$DOTFILES/.fonts" ~/.fonts
ln -sfv "$DOTFILES/.fonts.conf" ~/.fonts.conf
ln -sfv "$DOTFILES/.fonts.conf.d" ~/.fonts.conf.d
ln -sfv "$DOTFILES/.gtkrc-2.0" ~/.gtkrc-2.0
ln -sfv "$DOTFILES/.mplayer" ~/.mplayer
ln -sfv "$DOTFILES/.mpv" ~/.mpv

fc-cache -vf ~/.fonts
