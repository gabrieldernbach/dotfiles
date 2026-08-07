# Dotfiles

Personal macOS/Linux configuration for a consistent **Solarized Bright** setup across Ghostty, tmux, Neovim/Vim, and pi.

## Components

| Path | Purpose |
| --- | --- |
| `install.sh` | OS-aware, idempotent installer with backups for conflicting targets. |
| `ghostty/config.ghostty` | Ghostty palette, background, foreground, cursor, and selection colors. |
| `tmux.conf` | Modal navigation, mouse support, pane/window styling, and Solarized Bright status colors. |
| `nvim/init.vim` | Neovim clipboard integration, shared Vim runtime, filetype support, and colorscheme setup. |
| `vimrc` | Vim clipboard configuration. |
| `vim/colors/` | Shared Solarized colorschemes for Vim and Neovim, including Neovim Tree-sitter markup colors. |
| `pi/themes/solarized-bright.json` | Optional pi interactive theme. |

## Installation

The installer supports macOS and Linux. It creates parent directories, backs up conflicting targets under `~/.dotfiles-backups/`, and can be run repeatedly without replacing correct symlinks:

```sh
git clone https://github.com/gabrieldernbach/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Restart applications after installation. Reload an active tmux configuration with:

```sh
tmux source-file ~/.tmux.conf
```

## tmux controls

- `Ctrl-a`: toggle between navigation and application input modes.
- Navigation mode: `h`, `j`, `k`, `l` or arrow keys select panes.
- `Ctrl-h` / `Ctrl-l`: switch windows.
- `|`: split horizontally; `-`: split vertically.
- `c`: create a new window.
- `Enter` or `Escape`: return to application input mode.
- Mouse clicks select panes and windows.

## Design notes

- Ghostty, tmux, and Neovim use the same Solarized Bright ANSI palette.
- Neovim intentionally uses terminal colors (`notermguicolors`) so the terminal palette remains the source of truth.
- Markdown files are detected by Neovim's filetype system and use Tree-sitter markup highlight mappings from the shared Solarized colorscheme.

## Contributing

Work on a new branch and open a pull request targeting `master`. Do not push directly to the default branch.
