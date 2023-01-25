_rcnt_files() {
    lines=(${(f)"$(~/.config/zsh/rcnt)"})
    local -a filelist
    for line in $lines
    do
        name=${line%:*}
        descr=${line##*:}
        filelist=($filelist $name:${descr})
    done
    _describe 'rcnt files' filelist
}
zle -C complete-rcnt menu-complete _generic
zstyle ':completion:complete-rcnt::::' completer _rcnt_files
bindkey '^R' complete-rcnt

rcnt_add() {
    args=(${(Q)${(z)1}})
    for arg in $args
    do
        if [[ -a $arg || \
        ! ($arg == -*) && \
        $arg =~ ^[A-Za-z0-9\./\ _-]+$ && \
        $arg =~ [\./] ]]; then
            local filepath=$(realpath $arg)
            # echo $filepath
        fi
    done
}
# add-zsh-hook preexec rcnt_add