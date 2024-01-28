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
