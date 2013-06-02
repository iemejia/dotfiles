set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

 " My Bundles here:
 "
 " original repos on github
 " Bundle 'tpope/vim-fugitive'
 " Bundle 'Lokaltog/vim-easymotion'
 " Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
 " Bundle 'tpope/vim-rails.git'
 " vim-scripts repos
 " Bundle 'L9'
 " Bundle 'FuzzyFinder'
 " non github repos
 " Bundle 'git://git.wincent.com/command-t.git'
 " ...

 filetype plugin indent on     " required!
 "
 " Brief help
 " :BundleList          - list configured bundles
 " :BundleInstall(!)    - install(update) bundles
 " :BundleSearch(!) foo - search(or refresh cache first) for foo
 " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
 "
 " see :h vundle for more details or wiki for FAQ
 " NOTE: comments after Bundle command are not allowed..

syntax on
set number
set incsearch
set ignorecase
set hlsearch
set infercase
set smartcase
set cursorline

" Theme
colorscheme Tomorrow-Night

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Automatically leave insert mode after 'updatetime' (4s by default)
" au CursHoldI * stopinsert

" Improve tab navegation
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>
map <C-L> :tabn<CR>
map <C-H> :tabp<CR>
