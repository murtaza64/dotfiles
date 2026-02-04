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
alias oc="opencode"
alias repo="gh repo view --web"
alias hound="duo hound"
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

alias '?'=ask
alias '?!'='ask -c'
alias '?y'='ask -y'

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

# Git worktree helpers
wt-add() {
  local project=$(basename $(git rev-parse --show-toplevel))
  local branch=$1
  local worktree_path="$HOME/worktrees/$project/$branch"
  mkdir -p "$HOME/worktrees/$project"
  git worktree add "$worktree_path" -b "$branch" 2>/dev/null || \
  git worktree add "$worktree_path" "$branch" || return 1
  tmux-sessionizer "$worktree_path"
}

wt-rm() {
  local branch=$1
  local project
  local worktree_path
  local session_name
  local main_repo

  # If no branch provided, try to detect from current directory
  if [[ -z "$branch" ]]; then
    if [[ "$PWD" == "$HOME/worktrees/"* ]]; then
      # Extract project and branch from current path: ~/worktrees/project/branch/...
      local rel_path="${PWD#$HOME/worktrees/}"
      project="${rel_path%%/*}"
      local rest="${rel_path#*/}"
      branch="${rest%%/*}"
      if [[ -z "$branch" || "$branch" == "$project" ]]; then
        echo "Could not detect worktree branch from current directory" >&2
        return 1
      fi
    else
      echo "Not in a worktree and no branch specified" >&2
      return 1
    fi
  else
    project=$(basename $(git rev-parse --show-toplevel 2>/dev/null)) || {
      echo "Not in a git repository" >&2
      return 1
    }
  fi

  worktree_path="$HOME/worktrees/$project/$branch"
  session_name="${project}@${branch}"
  main_repo="$HOME/$project"

  if [[ ! -d "$worktree_path" ]]; then
    echo "Worktree not found: $worktree_path" >&2
    return 1
  fi

  if [[ ! -d "$main_repo/.git" ]]; then
    echo "Main repo not found: $main_repo" >&2
    return 1
  fi

  # Check for dirty state or unpushed commits
  local is_dirty=0
  local has_unpushed=0
  local warnings=""

  if [[ -n $(git -C "$worktree_path" status --porcelain 2>/dev/null) ]]; then
    is_dirty=1
    warnings+="  - Uncommitted changes\n"
  fi

  if git -C "$worktree_path" rev-parse @{u} &>/dev/null; then
    local unpushed=$(git -C "$worktree_path" log @{u}.. --oneline 2>/dev/null)
    if [[ -n "$unpushed" ]]; then
      has_unpushed=1
      warnings+="  - Unpushed commits:\n$(echo "$unpushed" | sed 's/^/      /')\n"
    fi
  else
    # No upstream, check if there are any commits
    local commits=$(git -C "$worktree_path" log --oneline -5 2>/dev/null)
    if [[ -n "$commits" ]]; then
      has_unpushed=1
      warnings+="  - Branch has no upstream (commits may be lost)\n"
    fi
  fi

  # Show warnings if any
  if [[ -n "$warnings" ]]; then
    echo "Warning: $session_name has:"
    echo -e "$warnings"
  fi

  # First confirmation
  echo -n "Remove worktree '$session_name' and kill session? [y/N] "
  read -r confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "Aborted"
    return 0
  fi

  # Double confirm if dirty or unpushed
  if [[ $is_dirty -eq 1 || $has_unpushed -eq 1 ]]; then
    echo -n "Are you SURE? This will discard uncommitted/unpushed work! [yes/N] "
    read -r confirm2
    if [[ "$confirm2" != "yes" ]]; then
      echo "Aborted"
      return 0
    fi
  fi

  # Remove worktree (force if dirty) - run from main repo
  echo "Removing worktree: $worktree_path"
  if [[ $is_dirty -eq 1 ]]; then
    git -C "$main_repo" worktree remove --force "$worktree_path"
  else
    git -C "$main_repo" worktree remove "$worktree_path"
  fi

  # Kill tmux session at the very end (switch first, then kill)
  if tmux has-session -t "$session_name" 2>/dev/null; then
    # Switch to main repo session first if it exists
    if tmux has-session -t "$project" 2>/dev/null; then
      tmux switch-client -t "$project"
    fi
    echo "Killing session: $session_name"
    tmux kill-session -t "$session_name"
  fi

  echo "Done"
}

wt-ls() {
  git worktree list
}

_get_wt_project() {
  # Get the project name, handling both main repo and worktree cases
  local toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
  [[ -z "$toplevel" ]] && return 1

  if [[ "$toplevel" == "$HOME/worktrees/"* ]]; then
    # We're in a worktree: ~/worktrees/project/branch
    local rel="${toplevel#$HOME/worktrees/}"
    echo "${rel%%/*}"
  else
    # We're in main repo
    basename "$toplevel"
  fi
}

wt() {
  local project=$(_get_wt_project) || {
    echo "Not in a git repository" >&2
    return 1
  }

  if [[ -n "$1" ]]; then
    if [[ "$1" == "main" ]]; then
      # Switch to main project session
      tmux-sessionizer "$HOME/$project"
    else
      # Direct switch to specified worktree
      tmux-sessionizer "$HOME/worktrees/$project/$1"
    fi
  else
    # Show fzf picker
    tmux-sessionizer --worktrees "$project"
  fi
}

_wt() {
  local project=$(_get_wt_project)
  [[ -z "$project" ]] && return 1

  local worktree_dir="$HOME/worktrees/$project"
  local worktrees=("main")

  if [[ -d "$worktree_dir" ]]; then
    worktrees+=("${(@f)$(ls -1 "$worktree_dir" 2>/dev/null)}")
  fi

  _describe 'worktree' worktrees
}
compdef _wt wt
