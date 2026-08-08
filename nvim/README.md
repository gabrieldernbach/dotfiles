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

These examples use a common leader-key namespace; the corresponding commands are provided by the relevant plugins or mappings.

## Buffer navigation

The buffer mappings follow the paired `[`/`]` convention from [vim-unimpaired](https://github.com/tpope/vim-unimpaired):

| Mapping | Action |
| --- | --- |
| `[b` | Go to the previous buffer |
| `]b` | Go to the next buffer |

Both mappings are available in normal mode and call `:bprevious` and `:bnext`, respectively.
