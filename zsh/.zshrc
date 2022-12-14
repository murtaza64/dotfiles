ZSH_ROOT=~/.config/zsh
autoload -Uz compinit
compinit
ZSHRCLOG=0
function log {
    if [[ $ZSHRCLOG -ne 0 ]]; then
        echo "zshrc: $1"
    fi
}

# borrowed from oh-my-zsh
# init some plugins, options and prompt theme
ZSH_ALIAS_FINDER_AUTOMATIC=true
for zshfile ($ZSH_ROOT/*.zsh); do
    source $zshfile
done

source $ZSH_ROOT/murtaza.zsh-theme

# custom aliases
alias less='less --mouse --wheel-lines 3'
export PAGER='less --mouse --wheel-lines 3'
alias grep='grep --color=auto'

# fuck
if command -v thefuck >/dev/null; then
    eval $(thefuck --alias)
else
    log "thefuck not found"
fi

# pyenv
if [[ -a $HOME/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
else
    log "pyenv not found"
fi

# fzf
if [[ -f "/usr/share/doc/fzf" ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    export FZF_DEFAULT_OPTS="--multi --bind 'ctrl-a:select-all'"
else
    log "fzf not found"
fi

function h {
    if [ "$#" -eq 0 ]; then
        local cmd=$(history | sed "s/^[ \t]*//" \
            | sed "s/^[0-9]\+\s\+//" | tac | awk '!seen[$0]++' | fzf)
    else
        local cmd=$(history | sed "s/^[ \t]*//" \
            | sed "s/^[0-9]\+\s\+//" | tac | awk '!seen[$0]++' | fzf -q ${(j[ ])@})
    fi
    if [[ ! -z $cmd ]]; then
        echo $cmd
        print -s $cmd
        eval $cmd
    else
        return 2
    fi
}

source "$ZSH_ROOT/rcnt.zsh"

# spacevim
export SPACEVIMDIR=.config/SpaceVim
