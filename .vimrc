"automatic update of .vimrc
autocmd! bufwritepost .vimrc source %

set nocompatible              " be iMproved, required
filetype off                  " required

"vundle plugin loader
"update installation with :PluginInstall, :PluginClean
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required

"code folding for python, use 'za'
Plugin 'https://github.com/tmhedberg/SimpylFold'
"python code completion and go to definition:
Plugin 'Valloric/YouCompleteMe' "heavy completion tool, compiled install!
"Plugin 'vim-syntastic/syntastic' "check syntax on safe
"Plugin 'nvie/vim-flake8' "check pep8 conformit
Plugin 'tpope/vim-fugitive' "command git inside vim
Plugin 'vim-syntastic/syntastic' "syntax check


"SYNTAX Tutorial
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive' "command git inside vim
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git' "fast file fuzzy search

call vundle#end()            " required
filetype plugin indent on    " required


syntax on "let vim highligh syntax
set encoding=utf-8

set mouse=a "activate mouse navigation
set clipboard=unnamed "make copy paste from clipboard default
set backspace=2 "make backspace delete indentations etc.

"better looks:
set cursorline "highlight line of curosor
set showmatch "highlight matching paranthesis
set wildmenu "autocompletion in command line will be shown as tags
set incsearch "search as characters are entered
set hlsearch "highlight search terms in text

"Enable folding:
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

"look for wombat color scheme on vim.org/scripts
"create a folder ~/.vim/colors and put it there (with .vim ending)
set t_Co=256
color wombat256mod

set number  "show line numbers
highlight ColorColumn ctermbg=233
set scrolloff=3 " Keep 3 lines below and above the cursor
set splitright " default split to open on the right side

set history=700
set undolevels=700 " increase undos possible by u, redo by ctrl+r

let mapleader=',' "make a map leader key ','

"easier movement between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
map <Leader>t <esc>:tabnew<CR>
map <Leader>w <esc>:tabclose<CR>

"move around windows
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

"avoid losing selection when indenting
vnoremap < <gv 
vnoremap > >gv

"make shortcuts for text mode, movement and deletion
:imap <C-h> <C-o>h
:imap <C-j> <C-o>j
:imap <C-k> <C-o>k
:imap <C-l> <C-o>l
:imap <C-x> <C-o>x
:imap <C-u> <C-o>u

"shortcut to save a file
noremap <Leader>s :update<CR>
"shortcut to run a file in python
noremap <Leader>f :!clear; ipython %<CR>
"shortcut for breakpoint
noremap <Leader>b Oimport ipdb; ipdb.set_trace()<Esc>
"print selection "not correctly working yet!
noremap <Leader>p cprint()<Esc>hp


au BufNewFile,BufRead *.py "only when working on .py files
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
	"set nowrap  "do not automatically wrap
	"set tw=79   "width of document (used by gd)
	"set fo-=t   "automatically wrap text when typing 
	"set colorcolumn=80 "adds a bar to the end of line

"jump to function definition also outisde current buffer
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"tips and tricks:
"select whole paragraph with vip (visual, inside paragraph)
"switch the ending of visual selection the cursor lives with o
"make a mapping for breakpoints and for running commands
":term will give a terminal
":newtab creates another tab
":explore gives you an explorer
"move to next paragraph } or back {
":vs file makes a vertical split and loads file there
":ls view open buffers, :b num will open the respective number
":helptags ALL reload help of installed plugins
"activate your virtual environment before launching vim
