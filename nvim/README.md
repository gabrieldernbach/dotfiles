# Neovim configuration

This directory contains the Neovim entrypoint and its navigation conventions.

## Leader key

The leader key is remapped from the default `\\` to Space in `init.vim`. In the examples below, `<leader>` means pressing Space first:

| Mapping | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Grep or search text |
| `<leader>fb` | List or switch buffers |
| `<leader>bd` | Delete or close the current buffer |
| `<leader>mt` | Toggle Markdown rendering |
| `<leader>mh` | Toggle hybrid Markdown editing |
| `<leader>ms` | Toggle Markdown split preview |

These mappings are configured when the plugins below are available. `which-key.nvim` displays their descriptions as the key sequence is entered.

## Plugins

Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim), which bootstraps itself into Neovim's data directory on first startup:

- [lazy.nvim](https://github.com/folke/lazy.nvim) manages plugin installation and loading.
- [which-key.nvim](https://github.com/folke/which-key.nvim) shows available keybindings.
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) provides file, text, and buffer pickers.
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) provides Telescope's required dependency.
- [markview.nvim](https://github.com/OXY2DEV/markview.nvim) renders Markdown inline with hybrid and split preview modes.

Use `:Lazy` to inspect or update plugins. Markview requires Tree-sitter `markdown` and `markdown_inline` parsers; the current Neovim runtime includes them. Run `:checkhealth markview` if rendering is unavailable. The `<leader>fg` live-grep mapping also requires [ripgrep](https://github.com/BurntSushi/ripgrep).

## Buffer navigation

The buffer mappings follow the paired `[`/`]` convention from [vim-unimpaired](https://github.com/tpope/vim-unimpaired):

| Mapping | Action |
| --- | --- |
| `[b` | Go to the previous buffer |
| `]b` | Go to the next buffer |

Both mappings are available in normal mode and call `:bprevious` and `:bnext`, respectively.
