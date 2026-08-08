" Use the macOS system clipboard for ordinary yank and paste operations.
set clipboard=unnamedplus

" Use the light Catppuccin Latte palette consistently with Ghostty and tmux.
set background=light
set termguicolors
filetype plugin indent on
syntax enable
lua << EOF_LUA
require("catppuccin").setup({
  flavour = "latte",
  term_colors = false,
})
vim.cmd.colorscheme("catppuccin-latte")
EOF_LUA

" Navigate between buffers.
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

" Navigate the quickfix list.
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" Navigate the location list.
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>

" Navigate the tag stack.
nnoremap <silent> [t :tprevious<CR>
nnoremap <silent> ]t :tnext<CR>
