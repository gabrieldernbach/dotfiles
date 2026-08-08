" Use Space as the leader key.
let mapleader = " "

" Load the shared Vim runtime for colors and common autoloads.
set runtimepath^=~/.vim

" Bootstrap lazy.nvim.
lua << EOF_LUA
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\\nPress any key to exit...", "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
EOF_LUA

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

" Configure plugins with lazy.nvim.
lua << EOF_LUA
require("lazy").setup({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>b", group = "buffers" },
        { "<leader>m", group = "markdown" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep text" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "List buffers" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {},
  },
}, {
  checker = { enabled = true },
})

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>mt", "<cmd>Markview toggle<CR>", { desc = "Toggle Markdown rendering" })
vim.keymap.set("n", "<leader>mh", "<cmd>Markview hybridToggle<CR>", { desc = "Toggle hybrid Markdown editing" })
vim.keymap.set("n", "<leader>ms", "<cmd>Markview splitToggle<CR>", { desc = "Toggle Markdown split preview" })
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
