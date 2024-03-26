changed = $PROMPT_FIELDS["gitstatus.changed"]
untracked = $PROMPT_FIELDS["gitstatus.untracked"]
ahead = $PROMPT_FIELDS["gitstatus.ahead"]
behind = $PROMPT_FIELDS["gitstatus.behind"]
staged = $PROMPT_FIELDS["gitstatus.staged"]
branch = $PROMPT_FIELDS["gitstatus.branch"]
changed.prefix = " {YELLOW}!"
untracked.prefix = " {BLUE}?"
ahead.prefix = " {GREEN}↑"
behind.prefix = " {GREEN}↓"
staged.prefix = " {YELLOW}+"
branch.prefix = "{PURPLE}"

gitstatus = $PROMPT_FIELDS["gitstatus"]
gitstatus.fragments = (
    '.branch',
    '.ahead',
    '.behind',
    '.operations',
    '{RESET}',
    '.staged',
    '.conflicts',
    '.changed',
    '.deleted',
    '.untracked',
    '.stash_count',
    '.lines_added',
    '.lines_removed',
    '.clean'
)
$PROMPT_FIELDS["time_format"] = "%H:%M"
$PROMPT = '\n{env_name}{#999}{cwd} {gitstatus}{RESET} {RED}{last_return_code_if_nonzero:[{BOLD_INTENSE_RED}{}{RED}] }{RESET}\n{BOLD_BLUE}{last_return_code_if_nonzero:{BOLD_RED}}{prompt_end}{RESET} '
$RIGHT_PROMPT = '\n{#999}{localtime} {RESET}'
# $BOTTOM_TOOLBAR = "{RESET}{gitstatus}{RESET}"

$VI_MODE = True


aliases['gk'] = "git checkout"
aliases['gs'] = "git status"
aliases['gf'] = "git fetch"
aliases['gp'] = "git pull"
aliases['gP'] = "git push"
aliases['ga.'] = "git add ."
aliases['gd'] = "git diff"
aliases['gds'] = "git diff --staged"
aliases['gl'] = "git log --pretty=oneline-custom"
aliases['pr'] = "create-or-open-pr"
aliases['gcm'] = "git commit -m"
aliases['merge-master'] = "git checkout master && git pull && git checkout - && git merge --no-edit master"
aliases['gcam'] = "git commit -am @(' '.join($args))"
aliases['gcamp'] = "git commit -am @(' '.join($args)) && git push"
aliases['gcmp'] = "git commit -m @(' '.join($args)) && git push"



duo_gpt_cmd = "python3 ~/gpt.py --prompt='short-md' --postprocess-command='glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json'"
duo_gpt_cmd = ["python3", "~/gpt.py", "--prompt=short-md", "--postprocess-command=glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json"]
aliases['??'] = duo_gpt_cmd + ["continue"]
aliases['?c'] = duo_gpt_cmd + ["clear"]
aliases['?.'] = duo_gpt_cmd
aliases['?y'] = duo_gpt_cmd + ["copy"]

def ask_and_pipe_glow(args):
    gum spin --show-output -- python3 ~/gpt.py ask @(' '.join(args)) | glow -w 100 -s /Users/murtaza/dotfiles/glow-custom.json
aliases['?'] = ask_and_pipe_glow


