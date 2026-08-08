" Use Space as the leader key.
let mapleader = " "

" Load the shared vim-plug installation from ~/.vim.
set runtimepath^=~/.vim
if filereadable(expand("~/.vim/autoload/plug.vim"))
  call plug#begin(stdpath("data") . "/plugged")
  Plug 'folke/which-key.nvim'
  " Telescope requires plenary.nvim.
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  call plug#end()
endif

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

" Configure Telescope pickers and their leader-key groups.
lua << EOF_LUA
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  telescope.setup({})
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep text" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List buffers" })
  vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
end

local which_key_ok, which_key = pcall(require, "which-key")
if which_key_ok then
  which_key.setup({})
  which_key.add({
    { "<leader>f", group = "find" },
    { "<leader>b", group = "buffers" },
  })
end
EOF_LUA

" Navigate between buffers.
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
