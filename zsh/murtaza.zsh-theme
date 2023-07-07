PROMPT=$'\n'
if [[ -v SSH_CLIENT ]]; then
	PROMPT+='%{$FG[097]%}%n@%m '
fi
PROMPT+='%{$FG[247]%}%~%{$reset_color%} $(git_prompt_info)'
PROMPT+="%(?:%{$fg_bold[green]%}$:%{$FG[168]%}$)%{$reset_color%} "


ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[225]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"

export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

function zle-line-init zle-keymap-select {
    # local normal_prompt="%{$bg[blue]%}%{$fg_bold[black]%} NORMAL %{$reset_color%}"
    # local insert_prompt="%{$bg[green]%}%{$fg_bold[black]%} INSERT %{$reset_color%}"
    # RPS1="${${KEYMAP/vicmd/$normal_prompt}/(main|viins)/$insert_prompt}"
    # RPS2=$RPS1
    # zle reset-prompt
    if [[ ${KEYMAP} == vicmd ]] ||
	    [[ $1 = 'block' ]]; then
	echo -ne '\e[2 q'

    elif [[ ${KEYMAP} == main ]] ||
	    [[ ${KEYMAP} == viins ]] ||
	    [[ ${KEYMAP} = '' ]] ||
	    [[ $1 = 'beam' ]]; then
	echo -ne '\e[5 q'
    fi
}

zle -N zle-line-init
zle -N zle-keymap-select

