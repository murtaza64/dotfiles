_rcnt_files() {
    lines=(${(f)"$(~/.config/zsh/rcnt.py show)"})
    # lines=(${(f)"$(~/.config/zsh/rcnt)"})
    local -a filelist
    for line in $lines
    do
        name=${line%:*}
        descr=${line##*:}
        filelist=($filelist $name:${descr})
    done
    _describe -t rcnt-files 'rcnt files' filelist
}
zle -C complete-rcnt menu-complete _generic
zstyle ':completion:complete-rcnt::::' completer _rcnt_files
zstyle ':completion:complete-rcnt:*' list-grouped false
zstyle ':completion:complete-rcnt:*' sort false

bindkey '^R' complete-rcnt

rcnt_add() {
    args=(${(Q)${(z)1}})
    for arg in $args
    do
        if [[ -a $arg || \
        ! ($arg == -*) && \
        $arg =~ ^[A-Za-z0-9\./\ _-]+$ && \
        $arg =~ [\./] ]]; then
            $ZSH_ROOT/rcnt.py add $arg:a
        fi
    done
}
add-zsh-hook preexec rcnt_add