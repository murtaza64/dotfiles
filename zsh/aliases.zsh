# alias nvim="nvim-nightly"
alias gk="git checkout"
alias gs="git status"
alias gf="git fetch"
alias gpl="git pull"
alias ga.="git add ."
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --pretty=oneline-custom"
alias pr="create-or-open-pr"
alias ls="eza --icons always"
alias ll="eza --icons -al --git"
alias merge-master="git checkout master && git pull && git checkout - && git merge master"
gcam() {
  git commit -am "$*"
}
gcamp() {
  git commit -am "$*" && git push
}

alias glorms='git fetch && git log "origin/master" "origin/stable" "origin/release" --graph --decorate --pretty="%Cblue%h%Creset %Cgreen%ad%Creset %s %C(bold red)%d%Creset" --date=format-local:"%a %H:%M:%S"'

# repo-url() {
#   git remote get-url origin | sed 's_^git@github.com:\(.*\)\.git$_https://github.com/\1_g'
# }
# pr-for-commit() {
#   git show $1 -q --pretty=oneline \
#     | grep '(#\d\+)' -o | grep -o '\d\+' \
#     | sed 's_\(.*\)_https://github.com/duolingo/duolingo-web/pull/\1_'
# }

duo_gpt_cmd="duo gpt --prompt-file='/Users/murtaza/cli/short.prompt' --postprocess-command='python3 /Users/murtaza/scratch/murtaza/postprocess_gpt_output.py'"
alias '?'="$duo_gpt_cmd ask"
alias '??'="$duo_gpt_cmd continue"
alias '?!'="$duo_gpt_cmd clear"
alias '?.'="$duo_gpt_cmd"
duo_gpt_cmd=(
  duo gpt
  --prompt-file='/Users/murtaza/cli/short.prompt' 
  --postprocess-command='python3 /Users/murtaza/scratch/murtaza/postprocess_gpt_output.py'
)

ask_and_put_cmdline() {
  # ${=duo_gpt_cmd} ask | tee /tmp/gpt_command.txt
  $duo_gpt_cmd ask $* | tee /tmp/gpt_command.txt
  # remove comments
  cmd=$(cat /tmp/gpt_command.txt | sed 's_#.*__g' | sed '/^$/d' | sed 's/\x1b\[[0-9;]*m//g')
  # # put command on zsh command line
  print -z $cmd
  # send key <esc>dd to move the command into the register
  zle -U "\edd"
}
# zle -N ask_and_put_cmdline ask_and_put_cmdline

# download a jenkins log and open it in nvim
jl() {
  if [[ ! $1 =~ .*job/.*/[0-9]+ ]]; then
    echo "not a jenkins run url"
    return 1
  fi
  url=$(echo $1 | sed -E 's_(.*/job/.*/[0-9]+).*_\1/consoleText_')
  job_name=$(echo $1 | sed -E 's_.*/job/(.*)/[0-9]+.*_\1_')
  build_number=$(echo $1 | sed -E 's_.*/job/.*/([0-9]+).*_\1_')
  mkdir -p /Users/murtaza/jenkins_logs/$job_name
  if [[ ! -f /Users/murtaza/jenkins_logs/$job_name/$build_number.log ]]; then
    echo "downloading $url"
    curl $url -o /Users/murtaza/jenkins_logs/$job_name/$build_number.log
  fi
  nvim -c "term cat /Users/murtaza/jenkins_logs/$job_name/$build_number.log" -c "set ft=JenkinsLog"
}
