#!/usr/bin/env bash
set -euo pipefail

readonly DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly HOME_DIR="${HOME:?HOME must be set}"
readonly OS="$(uname -s)"
BACKUP_DIR=""

fail() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

if [[ -n "${XDG_CONFIG_HOME:-}" && "$XDG_CONFIG_HOME" != /* ]]; then
    fail "XDG_CONFIG_HOME must be an absolute path"
fi
readonly CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME_DIR/.config}"

link_target_matches() {
    local target="$1"
    local source="$2"

    # -ef follows the link and compares the resolved file or directory identity,
    # avoiding fragile string normalization for relative links and /var aliases.
    [[ "$target" -ef "$source" ]]
}

require_source() {
    local source="$1"

    [[ -e "$source" || -L "$source" ]] || fail "missing required source: $source"
}

backup_target() {
    local target="$1"
    local backup

    if [[ -z "$BACKUP_DIR" ]]; then
        local stamp
        stamp="$(date +%Y%m%d-%H%M%S)"
        BACKUP_DIR="$HOME_DIR/.dotfiles-backups/$stamp"
        local suffix=1
        while [[ -e "$BACKUP_DIR" || -L "$BACKUP_DIR" ]]; do
            BACKUP_DIR="$HOME_DIR/.dotfiles-backups/${stamp}-${suffix}"
            suffix=$((suffix + 1))
        done
        mkdir -p "$BACKUP_DIR"
    fi

    if [[ "$target" == "$HOME_DIR"/* ]]; then
        backup="$BACKUP_DIR/${target#"$HOME_DIR/"}"
    else
        backup="$BACKUP_DIR/$(basename "$target")"
    fi

    mkdir -p "$(dirname "$backup")"
    mv "$target" "$backup"
    printf 'backed up %s -> %s\n' "$target" "$backup"
}

link_file() {
    local source="$1"
    local target="$2"

    [[ -e "$source" || -L "$source" ]] || fail "missing source: $source"
    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]] && link_target_matches "$target" "$source"; then
        printf 'ok %s\n' "$target"
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        backup_target "$target"
    fi

    ln -s "$source" "$target"
    printf 'linked %s -> %s\n' "$target" "$source"
}

link_optional() {
    local source="$1"
    local target="$2"

    if [[ -e "$source" || -L "$source" ]]; then
        link_file "$source" "$target"
    else
        printf 'skipping missing optional source: %s\n' "$source"
    fi
}

required_sources=(
    "$DOTFILES_DIR/tmux.conf"
    "$DOTFILES_DIR/vim"
    "$DOTFILES_DIR/vimrc"
    "$DOTFILES_DIR/.zprofile"
    "$DOTFILES_DIR/.zshrc"
    "$DOTFILES_DIR/.gitconfig"
    "$DOTFILES_DIR/nvim/init.vim"
    "$DOTFILES_DIR/ghostty/config.ghostty"
    "$DOTFILES_DIR/pi/settings.json"
)
for source in "${required_sources[@]}"; do
    require_source "$source"
done

case "$OS" in
    Darwin)
        ghostty_target="$HOME_DIR/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
        ;;
    Linux)
        ghostty_target="$CONFIG_DIR/ghostty/config.ghostty"
        ;;
    *)
        fail "unsupported operating system: $OS (supported: Darwin and Linux)"
        ;;
esac

canonical_existing_dir() {
    local path="$1"

    if [[ -d "$path" ]]; then
        (cd -P "$path" && pwd -P)
    else
        printf '%s\n' "$path"
    fi
}

reject_checkout_root() {
    local root="$1"
    local canonical_root

    canonical_root="$(canonical_existing_dir "$root")" || fail "cannot inspect installation target root: $root"
    case "$canonical_root" in
        "$DOTFILES_DIR"|"$DOTFILES_DIR/"*)
            fail "installation target is inside the dotfiles checkout: $root"
            ;;
    esac
}

# Every destination is rooted in HOME_DIR or CONFIG_DIR. Check both before
# creating any directories, links, or backups.
reject_checkout_root "$HOME_DIR"
reject_checkout_root "$CONFIG_DIR"

link_file "$DOTFILES_DIR/tmux.conf" "$HOME_DIR/.tmux.conf"
link_file "$DOTFILES_DIR/vim" "$HOME_DIR/.vim"
link_file "$DOTFILES_DIR/vimrc" "$HOME_DIR/.vimrc"
link_file "$DOTFILES_DIR/.zprofile" "$HOME_DIR/.zprofile"
link_file "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc"
link_file "$DOTFILES_DIR/.gitconfig" "$HOME_DIR/.gitconfig"
link_file "$DOTFILES_DIR/nvim/init.vim" "$CONFIG_DIR/nvim/init.vim"
link_optional "$DOTFILES_DIR/nvim/pack" "$CONFIG_DIR/nvim/pack"
link_file "$DOTFILES_DIR/ghostty/config.ghostty" "$ghostty_target"
link_file "$DOTFILES_DIR/pi/settings.json" "$HOME_DIR/.pi/agent/settings.json"
link_optional "$DOTFILES_DIR/pi/themes/solarized-bright.json" \
    "$HOME_DIR/.pi/agent/themes/solarized-bright.json"

printf 'installed dotfiles for %s from %s\n' "$OS" "$DOTFILES_DIR"
if [[ -n "$BACKUP_DIR" ]]; then
    printf 'backups: %s\n' "$BACKUP_DIR"
fi
