" separated gvim specific options file

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=e  "text based tab line

" set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12
" set guifont=Meslo\ LG\ S\ for\ Powerline\ Regular\ 10

" MacVim settings
" if has("mac")
"     set guifont=Menlo\ For\ Powerline
" endif
"
if has("gui_running")
    set guifont=Meslo\ LG\ S\ for\ Powerline\ Regular\ 10

"   if has("gui_gtk2")
" "    set guifont=Inconsolata\ 12
"   elseif has("gui_macvim")
"     " For powerline font in MacVim
"     "set guifont=Menlo\ Regular:h14
"     "set guifont=Monaco:h14
"   elseif has("gui_win32")
"     set guifont=Consolas:h11:cANSI
"   endif
endif

set lines=90
set columns=80

