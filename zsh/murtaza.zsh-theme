PROMPT=$'\n'
if [[ -v SSH_CLIENT ]]; then
	PROMPT+='%{$FG[097]%}%n@%m '
fi
PROMPT+='%{$FG[247]%}%~%{$reset_color%} $(git_prompt_info)'
PROMPT+="%(?:%{$fg_bold[green]%}$:%{$FG[168]%}%B$%b)%{$reset_color%} "


ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[225]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} 󰷬 "
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg[green]%} 󰭽 "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg[yellow]%} 󰭾 "
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg[red]%} 󰭾 󰭽 "
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"

export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"


