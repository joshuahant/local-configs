"Leader section
let mapleader=","       " map leader to ,

syntax enable           " enable syntax processing
set t_Co=256
if has('gui_running')
    set guioptions-=T   "remove toolbar
    set guioptions-=m   "remove menu bar
else
    set term=screen-256color
endif
    set background=dark

colorscheme solarized
set termguicolors

"tabs section
set tabstop=4           " nuber of visual spaces per TAB
set shiftwidth=4        " automatic indent
set expandtab           " tabs are spaces
set smarttab            " Treat shiftwidth spaces as a 'virtual tab'
set shiftround          " Round shift operators '>' and '<' to a multiple of shiftwidth

"UI section
set number              " show line nunmbers
set showcmd             " show last command in bottomm bar
set cursorline          " highlight currentline
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to
set showmatch           " highlight matching [{()}]
set autoread            " Automatically update files if changed outside of vim

"display trailing white space, eol, etc.
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
set list

"Searching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

"Movement
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
" Remap VIM 0 to first non-blank character
map 0 ^C-l> <C-W>l

" save session of windows - open them with vim -S
" nnoremap <leader>s :mksession<CR>

" open ag.vim
"nnoremap <leader>a :Ag

"CtrlP settings
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" allows cursor change in tmux mode change to vertical bar cursor
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"autogroups set settings based on file type
augroup vimrc
autocmd!
    autocmd BufNewFile *.py 0put =\"#!/usr/bin/python3\<nl>\"|$
    autocmd BufNewFile *.sh 0put =\"#!/usr/bin/sh\<nl>\"|$
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" back up section
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
let l:currentBufNum = bufnr("%")
let l:alternateBufNum = bufnr("#")

if buflisted(l:alternateBufNum)
    buffer #
else
    bnext
endif

if bufnr("%") == l:currentBufNum
    new
endif

if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
endif
endfunction
