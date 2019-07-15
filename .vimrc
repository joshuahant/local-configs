if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
"nerdtree
Plug 'scrooloose/nerdtree'
" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
  " Both options are optional. You don't have to install fzf in ~/.fzf
  " and you don't have to run install script if you use fzf only in Vim.
  "
"buffexplorer
Plug 'jlanzarotta/bufexplorer'

"solarized colors
Plug 'ericbn/vim-solarized'

"New syntax
Plug 'sheerun/vim-polyglot'

"status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

"Leader section
let mapleader=","       " map leader to ,

syntax on           " enable syntax processing
set t_Co=256
set background=dark
colorscheme solarized
set termguicolors

if has('gui_running')
    set guioptions-=T   "remove toolbar
    set guioptions-=m   "remove menu bar
endif

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

"vim-airline/vim-airline setup
set laststatus=2
let g:airline#extensions#tabline#enabled = 1 " Show buffer list in airline
let g:airline_powerline_fonts = 1 " Use Powerline fonts
let g:airline_theme='dark'
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

"Nerdtree mapping
nnoremap <silent> <F11> :NERDTreeToggle<CR>
nnoremap <silent> <C-F11> :NERDTreeFind<CR>

map <F12> :buffers<BAR>
           \let i = input("Buffer number: ")<BAR>
           \execute "buffer " . i<CR>

map <C-p> :Files<CR>

" leader f to search for filename under cursor using fzf
nnoremap <leader>f <Esc>:call fzf#vim#files('', {'options':'--query='.fzf#shellescape(expand('<cfile>:t'))})<CR>

" leader o to open directory of the current file.
nnoremap <leader>o <Esc>:exec "e " . expand('%:p:h')<CR>
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
