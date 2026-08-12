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
alias blocksleep-on='sudo pmset -a disablesleep 1'
alias blocksleep-off='sudo pmset -a disablesleep 0'

lfm_start() {
    local model='LiquidAI/LFM2.5-2.6B-MLX-4bit'
    local url='http://127.0.0.1:8080/v1/models'
    local cache_dir="$HOME/.cache/mlx-lm"
    local pid_file="$cache_dir/server.pid"
    local log_file="$cache_dir/server.log"

    if curl -fsS "$url" >/dev/null 2>&1; then
        print 'LFM server is already running on port 8080'
        return 0
    fi

    if (( ! $+commands[mlx_lm.server] )); then
        print -u2 'mlx_lm.server not found; install it with: uv tool install mlx-lm'
        return 1
    fi

    mkdir -p "$cache_dir"
    nohup mlx_lm.server --model "$model" --port 8080 >"$log_file" 2>&1 &
    print $! >| "$pid_file"

    for _ in {1..60}; do
        if curl -fsS "$url" >/dev/null 2>&1; then
            print "LFM server started on port 8080 (log: $log_file)"
            return 0
        fi
        sleep 1
    done

    print -u2 "LFM server did not start; see $log_file"
    return 1
}

lfm_stop() {
    local pid_file="$HOME/.cache/mlx-lm/server.pid"
    local pid

    if [[ ! -f "$pid_file" ]]; then
        print 'No LFM server started by lfm-start'
        return 0
    fi

    pid="$(<"$pid_file")"
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        print "Stopped LFM server (PID $pid)"
    else
        print "LFM server process $pid is not running"
    fi
    rm -f "$pid_file"
}

pi_lfm() {
    local was_running=0
    local exit_code

    if curl -fsS 'http://127.0.0.1:8080/v1/models' >/dev/null 2>&1; then
        was_running=1
    fi

    lfm_start || return
    pi --provider mlx-lm --model 'LiquidAI/LFM2.5-2.6B-MLX-4bit' "$@"
    exit_code=$?

    if (( ! was_running )); then
        lfm_stop
    fi
    return $exit_code
}

alias lfm-start='lfm_start'
alias lfm-stop='lfm_stop'
alias pi-lfm='pi_lfm'

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
