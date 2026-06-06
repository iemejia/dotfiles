" vim configuration file
" No external plugins required

set nocompatible
syntax on
filetype plugin indent on

" Sensible defaults (previously provided by vim-sensible plugin)
set complete-=i
set smarttab
set nrformats-=octal
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif
set incsearch
set laststatus=2
set wildmenu
set sidescroll=1
set sidescrolloff=2
set display+=lastline
if has('patch-7.4.2109')
  set display+=truncate
endif
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j
set autoread
set history=1000
set tabpagemax=50
set sessionoptions-=options
set viewoptions-=options
if has('langmap') && exists('+langremap') && &langremap
  set nolangremap
endif
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = '	'      " Tab as a local leader
let g:is_posix = 1             " vim's default is archaic bourne shell, bring it up to the 90s

" Fast saving
nmap <leader>w :w!<cr>

" Quit Files with Leader + q
noremap <leader>q :q<cr>

" save and exit
nmap <leader>x :wq!<cr>

" always show line numbers
"set number

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the WiLd menu
set wildmode=list:longest

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

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
"set clipboard=unnamed
set clipboard=unnamedplus
if has("mac") || system("uname") =~ "Darwin"
    set clipboard=unnamed
endif

" configure auto wrapping at 80 chars
set wrap
set textwidth=80

set tabstop=4
set shiftwidth=4
set expandtab

set infercase
set cursorline
set nonumber
set norelativenumber
set colorcolumn=81
set signcolumn=no

set encoding=utf-8
set noshowmode
set visualbell
set ttyfast
set mouse=a
if !has('nvim') && has('mouse_sgr')
  set ttymouse=sgr
endif

" Cursor shape: block in normal, beam in insert, underline in replace
if !has('gui_running')
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif

" Clean fill characters
set fillchars=vert:│,fold:─,foldopen:▾,foldclose:▸,foldsep:│

set lazyredraw
"set foldenable
"set foldlevelstart=10   " open most folds by default
"set foldnestmax=10      " 10 nested fold max
"set foldmethod=indent   " fold based on indent level

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
"map <space> /
"map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" New vertical split
nnoremap <leader>wv <c-w>v<c-w>l
nnoremap <leader>wh <c-w>s<c-w>l

map <leader>bo :only<cr>
map <leader>o :only<cr>
" Close the current buffer
map <leader>bc :bd<cr>
" Close all the buffers
map <leader>ba :1,1000 bd!<cr>
" close buffer but not split window
nmap <leader>bd :b#<bar>bd#<cr>

" move fast around buffers
nmap bt :bn<cr>
nmap bT :bp<cr>
nmap <leader>l :bn<cr>
nmap <leader>h :bp<cr>

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Change tab
noremap <S-l> gt
noremap <S-h> gT

" for linux and windows users (using the control key)
map <C-S-]> gt
map <C-S-[> gT
map <C-1> 1gt
map <C-2> 2gt
map <C-3> 3gt
map <C-4> 4gt
map <C-5> 5gt
map <C-6> 6gt
map <C-7> 7gt
map <C-8> 8gt
map <C-9> 9gt
map <C-0> :tablast<CR>

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
set termguicolors
set background=dark
colorscheme catppuccin

" Tabline colors: make inactive buffers readable
highlight TabLine      guifg=#cdd6f4 guibg=#45475a gui=NONE
highlight TabLineSel   guifg=#1e1e2e guibg=#89b4fa gui=bold
highlight TabLineFill  guifg=NONE    guibg=#1e1e2e gui=NONE

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

" Insert mode mappings
" better escape
inoremap jk <Esc>
inoremap kj <Esc>
" inoremap <Esc> <NOP>

" save on insert mode
inoremap <c-o> <c-o>:w<cr>
"inoremap <F2> <c-o>:w<cr>

" paste on insert mode
:inoremap kk <C-r><C-o>+

" Automatically leave insert mode after 'updatetime' (4s by default)
" au CursHoldI * stopinsert

" Improve tab navegation
" map <C-J> :bnext<CR>
" map <C-K> :bprev<CR>
" map <C-L> :tabn<CR>
" map <C-H> :tabp<CR>

" TeX / LaTeX related
let g:tex_flavor = "latex"

" Markdown
autocmd BufNewFile,BufRead *.md,*.markdown set filetype=markdown
let g:markdown_fenced_languages = ['python', 'bash=sh', 'javascript', 'vim', 'json', 'go', 'yaml', 'html', 'css']
let g:markdown_folding = 1
let g:markdown_minlines = 200
autocmd FileType markdown setlocal foldlevel=2 conceallevel=0

if !empty(&viminfo)
  set viminfo^=!
endif

" shortcuts for new lines without the annoying change to insert mode
nnoremap <CR> o<Esc>k
nnoremap <S-CR> O<Esc>j
"nnoremap ^M O<Esc>j "makes it work in CLI
" notice that impaired mode allows [<CR> and ]<CR>

nmap oo o<Esc>k

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap


" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ExtraWhitespace guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" rewrite enter behavior to have it different from o and O
" nmap <S-Enter> O<Esc>
" nmap <CR> o<Esc>

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>d "_D
vnoremap <leader>d "_D

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" Force linewise paste from system clipboard (useful for browser URLs)
nnoremap <leader>P :put! +<CR>
nnoremap <leader>p :put +<CR>


" decent mappings for vimdiff
nnoremap <expr> <C-H> &diff ? ':diffget 3<CR> :diffupdate<CR>' : '<C-W>h'
nnoremap <expr> <C-J> &diff ? ']c' : '<C-W>j'
nnoremap <expr> <C-K> &diff ? '[c' : '<C-W>k'
nnoremap <expr> <C-L> &diff ? ':diffget 1<CR> :diffupdate<CR>' : '<C-W>l'

" Fix spelling with <leader>f
nnoremap <leader>f 1z=
" Toggle spelling visuals with <leader>s
nnoremap <leader>s :s spell!<cr>
" enable repetition in normal mode (e.g. for prepending)
vnoremap . :norm.<CR>

" Apply Macros with Q remember you record with qq and stop with d
nnoremap Q @q
vnoremap Q :norm @q<cr>

" align current paragraph
noremap <leader>a =ip

" visual shifting (does not exit Visual mode)
vnoremap < <gv vnoremap=""> >gv

" re-indent whole file
map <leader>= mzgg=G`z

" Show open buffers in the tabline
set tabline=%!MyTabLine()
function! MyTabLine()
  let s = ''
  for i in range(1, bufnr('$'))
    if buflisted(i)
      let s .= (i == bufnr('%') ? '%#TabLineSel#' : '%#TabLine#')
      let s .= ' ' . fnamemodify(bufname(i), ':t') . ' '
    endif
  endfor
  let s .= '%#TabLineFill#'
  return s
endfunction

" Status line
set statusline=
set statusline+=\ %{toupper(mode())}        " mode
set statusline+=\ │\ %f                      " file path
set statusline+=%m%r                         " modified/readonly flags
set statusline+=%=                           " right align
set statusline+=%y\                          " filetype
set statusline+=│\ %l:%c\ │\ %p%%\          " line:col | percent

" switch to previous file
nnoremap <leader><leader> <c-^>

" Edit files in same directory as current file
cnoremap %% <c-r>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>E :Explore<cr>
map <leader>d :bd<cr>

" Bubble single lines, betteth [er
"nmap <C-Up> ddkP
"nmap <C-Down> ddp

" Bubble multiple lines
"vmap <C-Up> xkP`[V`]
"vmap <C-Down> xp`[V`]

" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp
" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" Visually select the text that was last edited/pasted
" remember that gv re selects the last edit
nmap gV `[v`]

" wrapping and indenting code
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nmap \w :setlocal wrap!<CR>:setlocal wrap?<CR>

" " Allow netrw buffer to be wiped
autocmd FileType netrw setl bufhidden=wipe

" Get rid of the annoying netrw view on macvim
let loaded_netrwPlugin = 1

" Open URL under cursor with gx (netrw is disabled)
function! s:OpenURL()
  let l:url = matchstr(expand('<cWORD>'), 'https\?://[^ >)},;:"'']*')
  if l:url != ''
    if has('mac') || system('uname') =~ 'Darwin'
      call system('open ' . shellescape(l:url))
    else
      call system('xdg-open ' . shellescape(l:url))
    endif
  endif
endfunction
nnoremap gx :call <SID>OpenURL()<CR>

" OSC 52 clipboard support for SSH/tmux
" Sends yanked text to local system clipboard via terminal escape sequence

function! s:OscYank(text)
  let encoded = system('base64 | tr -d "\n"', a:text)
  call system('printf "\033]52;c;%s\033\\" ' . shellescape(encoded) . ' > /dev/tty')
endfunction

augroup osc52_clipboard
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' | call <SID>OscYank(join(v:event.regcontents, "\n")) | endif
augroup END

