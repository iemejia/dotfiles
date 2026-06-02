#!/bin/sh
# Install vim plugins using native packages (vim 8+)
# Plugins go into ~/.vim/pack/plugins/start/
set -e

PACK_DIR="$HOME/.vim/pack/plugins/start"
mkdir -p "$PACK_DIR"

plugins="
airblade/vim-gitgutter
cazador481/vim-nfo
chriskempson/base16-vim
christoomey/vim-tmux-navigator
davidhalter/jedi-vim
dbakker/vim-lint
editorconfig/editorconfig-vim
easymotion/vim-easymotion
godlygeek/tabular
itchyny/lightline.vim
junegunn/fzf
junegunn/fzf.vim
mattn/emmet-vim
mengelbrecht/lightline-bufferline
michaeljsmith/vim-indent-object
mileszs/ack.vim
msanders/snipmate.vim
nanotech/jellybeans.vim
plasticboy/vim-markdown
rbgrouleff/bclose.vim
mg979/vim-visual-multi
tommcdo/vim-exchange
tomtom/tcomment_vim
tpope/vim-abolish
tpope/vim-commentary
tpope/vim-eunuch
tpope/vim-fugitive
tpope/vim-git
tpope/vim-obsession
tpope/vim-sensible
tpope/vim-surround
tpope/vim-unimpaired
vim-scripts/closetag.vim
dense-analysis/ale
Yggdroot/indentLine
"

for plugin in $plugins; do
    name=$(basename "$plugin")
    if [ -d "$PACK_DIR/$name" ]; then
        echo "Updating $name..."
        git -C "$PACK_DIR/$name" pull --quiet
    else
        echo "Installing $name..."
        git clone --depth 1 --quiet "https://github.com/$plugin.git" "$PACK_DIR/$name"
    fi
done

echo "Done. Run :helptags ALL in vim to generate help tags."
