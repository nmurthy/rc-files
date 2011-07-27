syntax on
set guioptions-=T
filetype on
filetype plugin on
filetype indent on
set nocompatible
set bg=dark

" Line Numbering
set number

set tabstop=4
set shiftwidth=4
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab

set printoptions=number:y;paper:letter

ab #b /************************************************
ab #e ************************************************/

set backspace=indent,eol,start

set grepprg=grep\ -nH\ $*

let g:tex_flavor='latex'

set foldmethod=marker
set commentstring=\ #\ %s
set foldlevel=100

set ruler "show line and column number
set wildmenu "show some autocomplete options in statusbar
filetype plugin indent on

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType ruby set ts=2 sw=2
" Get equally spaced buffer windows independent of main gvim window size in ipython
autocmd VimResized * wincmd =

" don't clog cwd with .swp files
set backup
set backupdir=$HOME/.vimbackup/
set directory=$HOME/.vimswap/
set viewdir=$HOME/.vimviews/

colo ir_black
