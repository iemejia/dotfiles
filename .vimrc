" vim configuration file
" vastly copied from http://amix.dk/vim/vimrc.html

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'gmarik/snipmate.vim'
Bundle 'ervandew/supertab'
Bundle 'scrooloose/syntastic'
Bundle 'dbakker/vim-lint'
Bundle 'vim-scripts/autocorrect.vim'
Bundle 'jcf/vim-latex'
Bundle 'kien/ctrlp.vim'
Bundle 'terryma/vim-multiple-cursors'
if has('mac')
  Bundle 'Lokaltog/powerline'
  Bundle 'davidhalter/jedi-vim'
else
  Bundle 'bling/vim-airline'
" Bundle 'itchyny/lightline.vim'
endif
Bundle 'vim-scripts/closetag.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'chriskempson/base16-vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'nanotech/jellybeans.vim'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'mattn/emmet-vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'klen/python-mode'

" Bundle 'Lokaltog/vim-easymotion'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'tpope/vim-rails.git'
" vim-scripts repos
" Bundle 'L9'
" Bundle 'FuzzyFinder'
" non github repos
" Bundle 'git://git.wincent.com/command-t.git'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
let maplocalleader = '	'      " Tab as a local leader
let g:is_posix = 1             " vim's default is archaic bourne shell, bring it up to the 90s

" Fast saving
nmap <leader>w :w!<cr>

" always show line numbers
set number 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the WiLd menu
set wildmode=list:longest

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" compatible copy/paste with mac
set clipboard=unnamed

" set textwidth=80
set infercase
set cursorline

set encoding=utf-8
set showmode
set visualbell
set ttyfast
set backspace=indent,eol,start
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

""""""""""""""""""""""""""""""
" => Visual mode related
" """"""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Make Y consistent with C and D.  See :help Y.
nnoremap Y y$

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Always autosave everything (Ignore warnings from untitled buffers)
au FocusLost * silent! wa

" Delete trailing white space on save, useful for Python and
" CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Theme
set background=dark
" let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-tomorrow

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
"imap <esc> <nop>

" Better esc in insert mode
inoremap jk <Esc>
inoremap kj <Esc>

" Automatically leave insert mode after 'updatetime' (4s by default)
" au CursHoldI * stopinsert

" Improve tab navegation
" map <C-J> :bnext<CR>
" map <C-K> :bprev<CR>
" map <C-L> :tabn<CR>
" map <C-H> :tabp<CR>

" TeX / LaTeX related
let g:tex_flavor = "latex"
" unset title off

if !empty(&viminfo)
  set viminfo^=!
endif

" shortcuts for new lines without the annoying change to insert mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
nmap oo o<Esc>k

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Automatically change the colorscheme for diff
if &diff
    colorscheme shine
endif

" vim-airline configuration
let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1
set noshowmode

" powerline configuration
if has("mac")
  let g:Powerline_symbols = 'fancy'
  let g:Powerline_cache_enabled = 1
  set rtp+=$HOME/.vim/bundle/powerline/powerline/bindings/vim/
  " For powerline font in MacVim
  set guifont=Menlo\ For\ Powerline
endif

" MacVim settings
:set guifont=Monaco:h14

" Enable move line up/down
"inoremap <C-s-k> ddkkp
"inoremap <C-s-j> ddp

" paste in new line (notice that if you yank a line you can do yyp
nmap <leader>p o<ESC>p

