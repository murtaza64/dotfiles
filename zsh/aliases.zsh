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
alias merge-master="git checkout master && git pull && git checkout - && git merge --no-edit master"
gcam() {
  git commit -am "$*"
}
gcamp() {
  git commit -am "$*" && git push
}
gcmp() {
  git commit -m "$*" && git push
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

duo_gpt_cmd="python3 ~/gpt.py --prompt='short-md' --postprocess-command='glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json'"
# alias '?'="$duo_gpt_cmd ask"
alias '??'="$duo_gpt_cmd continue"
alias '?!'="$duo_gpt_cmd clear"
alias '?.'="$duo_gpt_cmd"
alias '?y'="$duo_gpt_cmd copy"
duo_gpt_cmd=(
  python3 ~/gpt.py 
  --prompt='short-md' 
  --postprocess-command='glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json'
)

ask_and_pipe_glow() {
  gum spin --show-output -- python3 ~/gpt.py --prompt='short-md' ask $* | glow -w 100 -s ~/dotfiles/glow-custom.json
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
