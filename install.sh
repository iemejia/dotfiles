#!/usr/bin/env bash

#pip install --user powerline-status

ln -sfv ~/repositories/dotfiles/.bash_profile ~/.bash_profile
ln -sfv ~/repositories/dotfiles/.bash_logout ~/.bash_logout
ln -sfv ~/repositories/dotfiles/.bashrc ~/.bashrc
ln -sfv ~/repositories/dotfiles/.emacs.d ~/.emacs.d
ln -sfv ~/repositories/dotfiles/.gdbinit ~/.gdbinit
ln -sfv ~/repositories/dotfiles/.git-completion.bash ~/.git-completion.bash
ln -sfv ~/repositories/dotfiles/.gitconfig ~/.gitconfig
ln -sfv ~/repositories/dotfiles/.git_commit_msg.txt ~/.git_commit_msg.txt
ln -sfv ~/repositories/dotfiles/.inputrc ~/.inputrc
ln -sfv ~/repositories/dotfiles/.irssi ~/.irssi
ln -sfv ~/repositories/dotfiles/.latexmkrc ~/.latexmkrc
ln -sfv ~/repositories/dotfiles/.profile ~/.profile
ln -sfv ~/repositories/dotfiles/.screenrc ~/.screenrc
ln -sfv ~/repositories/dotfiles/.tmux/.tmux.conf ~/.tmux.conf
cp ~/repositories/dotfiles/.tmux/.tmux.conf.local ~/
ln -sfv ~/repositories/dotfiles/.vim ~/.vim
ln -sfv ~/repositories/dotfiles/.vimrc ~/.vimrc
ln -sfv ~/repositories/dotfiles/.gvimrc ~/.gvimrc
ln -sfv ~/repositories/dotfiles/.zprofile ~/.zprofile
ln -sfv ~/repositories/dotfiles/.zshrc ~/.zshrc
ln -sfv ~/repositories/dotfiles/.zshenv ~/.zshenv
ln -sfv ~/repositories/dotfiles/.oh-my-zsh ~/.oh-my-zsh
ln -sfv ~/repositories/dotfiles/.zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -sfv ~/repositories/dotfiles/.zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -sfv ~/repositories/dotfiles/.bash_it ~/.bash_it
ln -sfv ~/repositories/dotfiles/.xinitrc ~/.xinitrc
#cp -R ~/repositories/dotfiles/.fonts/* ~/.fonts/
#ln -sfv ~/Dropbox/static-resources/fonts/ .fonts
ln -sfv ~/repositories/dotfiles/.fonts ~/.fonts
ln -sfv ~/repositories/dotfiles/.fonts.conf ~/.fonts.conf
ln -sfv ~/repositories/dotfiles/.fonts.conf.d ~/.fonts.conf.d
ln -sfv ~/repositories/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0
ln -sfv ~/repositories/dotfiles/s3.exclude ~/s3.exclude
ln -sfv ~/repositories/dotfiles/.mplayer ~/.mplayer
ln -sfv ~/repositories/dotfiles/.mpv ~/.mpv
ln -sfv ~/Dropbox/Documents/research-notes ~/research-notes
ln -sfv ~/repositories/dotfiles/.hiverc ~/.hiverc
ln -sfv ~/repositories/dotfiles/.npmrc ~/.npmrc

# update scripts
mkdir -p ~/.local/bin

ln -sfv ~/repositories/dotfiles/update-docker.sh ~/.local/bin/update-docker.sh
ln -sfv ~/repositories/dotfiles/update-env.sh ~/.local/bin/update-env.sh
ln -sfv ~/repositories/dotfiles/update-linux.sh ~/.local/bin/update-linux.sh
ln -sfv ~/repositories/dotfiles/update-mac.sh ~/.local/bin/update-mac.sh
ln -sfv ~/repositories/dotfiles/update-repositories.sh ~/.local/bin/update-repositories.sh
ln -sfv ~/repositories/dotfiles/update-weekly.sh ~/.local/bin/update-weekly.sh

# tmux plugins
mkdir -p ~/.tmux/plugins
ln -sfv ~/repositories/dotfiles/.tpm ~/.tmux/plugins/tpm
ln -sfv ~/repositories/dotfiles/.tmuxline.theme ~/.tmuxline.theme

# subversion
mkdir -p ~/.subversion
ln -sfv ~/repositories/dotfiles/.subversion/servers ~/.subversion/servers

# note you must run tmux and then do C-a I
ln -sfv ~/repositories/dotfiles/.config/base16-shell ~/.config/base16-shell
ln -sfv ~/repositories/dotfiles/.fzf ~/.fzf
ln -sfv ~/repositories/dotfiles/.gradle-completion ~/.gradle-completion

# system aliases
ln -sfv /usr/share/vim/vim80/macros/less.sh ~/.local/bin/vless

mkdir -p ~/.m2
ln -sfv ~/repositories/dotfiles/.m2/settings.xml ~/.m2/settings.xml

mkdir -p ~/.gradle
ln -sfv ~/repositories/dotfiles/.gradle/gradle.properties ~/.gradle/gradle.properties

mkdir -p ~/.pip
ln -sfv ~/repositories/dotfiles/.pip/pip.conf ~/.pip/pip.conf
ln -sfv ~/repositories/dotfiles/.theanorc ~/.theanorc
ln -sfv ~/repositories/dotfiles/.keras ~/.keras

/usr/bin/yarn config set prefix ~/.node --global

# asdf defaults
ln -sfv ~/repositories/dotfiles/.tool-versions ~/.tool-versions

# sdkman configuration
mkdir -p ~/.sdkman/etc/config
ln -sfv ~/repositories/dotfiles/.sdkmanconfig ~/.sdkman/etc/config

# alacritty
mkdir -p ~/.config/alacritty
ln -sfv ~/repositories/dotfiles/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

fc-cache -vf ~/.fonts
~/.bash_it/install.sh
