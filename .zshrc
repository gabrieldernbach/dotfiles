# Interactive shell configuration.
[[ -o interactive ]] || return

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

# Keep completion setup in the interactive shell only.
autoload -Uz compinit
compinit

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"

alias ll='ls -lah'
alias la='ls -A'
alias gs='git status --short --branch'
alias gd='git diff'
alias gco='git checkout'
alias n='nvim'

# Make Homebrew available in non-login interactive shells too.
if (( ! $+commands[brew] )); then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

if (( $+commands[fzf] )); then
    eval "$(fzf --zsh)"
fi
