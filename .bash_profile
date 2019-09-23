alias python=python3

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

alias cluster="ssh gdernbach@cluster.ml.tu-berlin.de"

export PATH=/usr/local/bin:$PATH

# trash() { mv "$@" ~/.Trash/; && echo "deleted $@" } # safer way of deletion
trash() { for item in "$@" ; do echo "Trashing: $item" ; mv "$item" ~/.Trash/; done; }

