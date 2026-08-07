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

if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

if (( $+commands[fzf] )); then
    eval "$(fzf --zsh)"
fi
