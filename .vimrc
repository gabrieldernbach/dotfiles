"automatic update of .vimrc
autocmd! bufwritepost .vimrc source %

set nocompatible              " be iMproved, required
filetype off                  " required

"vundle plugin loader
"update installation with :PluginInstall, :PluginClean
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required

"Plugin 'davidhalter/jedi-vim'

"code folding for python, use 'za'
"Plugin 'https://github.com/tmhedberg/SimpylFold'
"python code completion and go to definition:
"Plugin 'Valloric/YouCompleteMe' "heavy completion tool, compiled install!
"Plugin 'tpope/vim-fugitive' "command git inside vim
"Plugin 'vim-syntastic/syntastic' "syntax check
"Plugin 'https://github.com/tpope/vim-unimpaired' "add some shortcuts as [<space> or [q to jump to next error

"Plugin 'https://github.com/lervag/vimtex' "latex shortcuts

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
set wildmode=list:longest,full
set incsearch "search as characters are entered
"set hlsearch "highlight search terms in text

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

"extend j k to work inside wrapped lines
map j gj
map k gk

"make shortcuts for text mode, movement and deletion
:imap <C-h> <C-o>h
:imap <C-j> <C-o>j
:imap <C-k> <C-o>k
:imap <C-l> <C-o>l
:imap <C-x> <C-o>x
:imap <C-u> <C-o>u
:imap <C-e> <C-o>$
:imap <C-a> <C-o>0

"shortcut to save a file
noremap <Leader>s :update<CR>

"au BufNewFile,BufRead *.py
    "shortcut to run a file in python
au filetype python noremap <Leader>f :!clear; ipython %<CR>
    "shortcut for breakpoint
au filetype python noremap <Leader>b Oimport ipdb; ipdb.set_trace()<Esc>
    "print selection "not correctly working yet!

au filetype tex noremap <Leader>f :!clear; pdflatex %; open %:r.pdf<CR>
"au BufNewFile,BufRead *.tex set tw=120

au filetype cpp nnoremap <Leader>f :!g++ -I ./ -std=c++11 % -Wall -g -o %.out && ./%.out<CR>


au BufNewFile,BufRead *.py "only when working on .py files
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
	"set nowrap  "do not automatically wrap
	"set tw=79   "width of document 
	"set fo-=t   "automatically wrap text when typing 
	"set colorcolumn=80 "adds a bar to the end of line


"configure Explorer:
let g:netrw_banner = 0 " hide banner, (show by I)
let g:netrw_browse_split = 3 " open file in new tab
let g:netrw_preview = 1 " show previews (p) vertical split

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

"generate tags for current project by:
"!ctags -R *.py

"generate tags for all libraries installed:
"!ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c 'import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))')

"jump to tag by <C-]> or if multiple possible g-<c-]>, go back by <C-t>

