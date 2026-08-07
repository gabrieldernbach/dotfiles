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
