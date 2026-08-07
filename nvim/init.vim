" Use the macOS system clipboard for ordinary yank and paste operations.
set clipboard=unnamedplus

" Use a dark Catppuccin palette, matching modern terminal tooling.
set termguicolors
filetype plugin indent on
syntax enable
lua << EOF_LUA
require("catppuccin").setup({ flavour = "mocha" })
vim.cmd.colorscheme("catppuccin-mocha")
EOF_LUA
