# alias nvim="nvim-nightly"
alias gk="git checkout"
alias gs="git status"
alias gf="git fetch"
alias gp="git pull"
alias gP="git push"
alias ga.="git add ."
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --pretty=oneline-custom"
alias pr="create-or-open-pr"
alias gcm="git commit -m"
if which eza > /dev/null; then
  alias ls="eza --icons always"
  alias ll="eza --icons -al --git"
fi
if which bat > /dev/null; then
  alias cat="bat"
fi
if [[ "$OSTYPE" == "linux-gnu"* ]] && which xdg-open > /dev/null; then
  alias open="xdg-open"
fi
alias merge-master="git checkout master && git pull && git checkout - && git merge --no-edit master"
gcam() {
  git commit -am "$*"
}
gcamp() {
  git commit -am "$*" && git push
}
gcnamp() {
  git commit -nam "$*" && git push
}
gcmp() {
  git commit -m "$*" && git push
}
quickpr() {
  (
    set -e
    commit_message="$*"
    branch_name="murtaza-$(echo $commit_message | tr '[:upper:]' '[:lower:]' | tr -cd '[:lower:][:digit:] ' | cut -d' ' -f-5 | tr ' ' '-')"
    current=$(git branch --show-current)
    if [[ $current == $branch_name ]]; then
      echo "Already on branch $branch_name, not switching"
    elif [[ $current != "master" ]]; then
      echo "Not on master branch"
      exit 1
    else
      git checkout -b $branch_name
    fi

    git commit -am "$commit_message"
    git push -u origin $branch_name
    gh pr create --head $branch_name --web
  )
}


alias glorms='git fetch && git log "origin/master" "origin/stable" "origin/release" --graph --decorate --pretty="%Cblue%h%Creset %Cgreen%ad%Creset %s %C(bold red)%d%Creset" --date=format-local:"%a %H:%M:%S"'

alias ''='nvim'

nvim () {
  restart=68
  while [[ $restart -eq 68 ]]; do
    command nvim $*
    restart=$?
  done
}

# duo_gpt_cmd="python3 ~/gpt.py --prompt='short-md' --postprocess-command='glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json'"
# alias '?'="$duo_gpt_cmd ask"
# alias '??'="$duo_gpt_cmd continue"
# alias '?!'="$duo_gpt_cmd clear"
# alias '?.'="$duo_gpt_cmd"
# alias '?y'="$duo_gpt_cmd copy"
# duo_gpt_cmd=(
#   python3 ~/gpt.py 
#   --prompt='short-md' 
#   --postprocess-command='glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json'
# )

# ask_and_pipe_glow() {
#   gum spin --show-output -- python3 ~/gpt.py --prompt='short-md' ask $* | glow -w 100 -s ~/dotfiles/glow-custom.json
# }
ask_and_pipe_glow() {
  gum spin --show-output --title "Clauding..." -- /Users/murtaza/.claude/local/claude --append-system-prompt "$(cat ~/scratch/murtaza/ai_prompts/short-md.prompt)" -p "$*" | glow -w 100 -s ~/dotfiles/glow-custom.json
}
alias '?'=ask_and_pipe_glow

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

tar-new-dir() {
  if [[ -z $1 ]]; then
    echo "Usage: tar-new-dir <archive>"
    return 1
  fi
  # exttract archive (e.g. xyz.tar.gz) to a new directory (e.g. xyz)
  dir=$(echo $1 | sed -E 's/\.tar\..*//')
  echo $dir
  mkdir $dir || (echo "directory already exists" >&2 && return 1)
  tar -xzf $1 -C $dir && cd $dir
}

ssh-cej-controller() {
  (
    set -eo pipefail
    ip=$(aws ec2 describe-instances --instance-ids \
          $(aws autoscaling describe-auto-scaling-groups --filters \
            'Name=tag:subservice,Values=controller' \
            'Name=tag:service,Values=client-eng-jenkins' \
            | jq '.AutoScalingGroups[].Instances[].InstanceId' -r) \
          | jq '.Reservations[].Instances[].PrivateIpAddress' -r | grep -v null)
    echo $ip
    if [[ -z $ip ]]; then
      echo "No instance found"
      exit 1
    fi
    TERM=xterm ssh -i ~/.ssh/id_rsa_tri_team ec2-user@$ip
  )
}

ssh-ec2-instance() {
  (
    set -eo pipefail
    ip=$(aws ec2 describe-instances --instance-id $1 | jq -r '.Reservations[].Instances[].PrivateIpAddress')
    echo $ip
    if [[ -z $ip ]]; then
      echo "No instance found with id $1"
      exit 1
    fi
    user=${2:-ec2-user}
    TERM=xterm ssh -i ~/.ssh/id_rsa_tri_team $user@$ip
  )
}

alias wal="uv run --directory ~/pywal -m pywal -i"
alias walm="uv run --directory ~/pywal -m pywal --modify"
alias wals="uv run --directory ~/pywal -m pywal --modify --shuffle"

alias ipython="uv run --with ipython ipython"
