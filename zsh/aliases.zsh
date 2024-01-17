alias gk="git checkout"
alias gs="git status"
alias gf="git fetch"
alias gpl="git pull"
alias ga.="git add ."
alias merge-master="git checkout master && git pull && git checkout - && git merge master"
gcam() {
  git commit -am "$*"
}
gcamp() {
  git commit -am "$*" && git push
}

alias glorms='git fetch && git log "origin/master" "origin/stable" "origin/release" --graph --decorate --pretty="%Cblue%h%Creset %Cgreen%ad%Creset %s %C(bold red)%d%Creset" --date=format-local:"%a %H:%M:%S"'

repo-url() {
  git remote get-url origin | sed 's_^git@github.com:\(.*\)\.git$_https://github.com/\1_g'
}
pr-for-commit() {
  git show $1 -q --pretty=oneline \
    | grep '(#\d\+)' -o | grep -o '\d\+' \
    | sed 's_\(.*\)_https://github.com/duolingo/duolingo-web/pull/\1_'
}
