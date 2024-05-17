#!/usr/bin/env bash
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
  local option value default
  option="$1"
  default="$2"
  value="$(tmux show-option -gqv "$option")"

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

set() {
  local option=$1
  local value=$2
  tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
  local option=$1
  local value=$2
  tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

main() {
  local theme
  theme="$(get_tmux_option "@catppuccin_flavour" "mocha")"

  # Aggregate all commands in one array
  local tmux_commands=()

  # NOTE: Pulling in the selected theme by the theme that's being set as local
  # variables.
  # shellcheck source=catppuccin-frappe.tmuxtheme
  source /dev/stdin <<<"$(sed -e "/^[^#].*=/s/^/local /" "${PLUGIN_DIR}/catppuccin-${theme}.tmuxtheme")"

  # status
  set status "on"
  set status-bg default
  setw window-status-style bg=default
  set status-style bg=default
  set status-justify "absolute-centre"
  set status-left-length "100"
  set status-right-length "100"

  # messages
  set message-style "fg=${thm_cyan},bg=${thm_gray},align=centre"
  set message-command-style "fg=${thm_cyan},bg=${thm_gray},align=centre"

  # panes
  set pane-border-style "fg=${thm_gray}"
  set pane-active-border-style "fg=${thm_blue}"

  # windows
  setw window-status-activity-style "fg=${thm_fg},bg=${thm_bg},none"
  setw window-status-separator ""
  # setw window-status-style "fg=${thm_fg},bg=${thm_bg},none"

  # --------=== Statusline

  # NOTE: Checking for the value of @catppuccin_window_tabs_enabled
  local wt_enabled
  wt_enabled="$(get_tmux_option "@catppuccin_window_tabs_enabled" "off")"
  readonly wt_enabled

  local right_separator
  right_separator="$(get_tmux_option "@catppuccin_right_separator" "")"
  readonly right_separator

  local left_separator
  left_separator="$(get_tmux_option "@catppuccin_left_separator" "")"
  readonly left_separator

  local user
  user="$(get_tmux_option "@catppuccin_user" "off")"
  readonly user

  local user_icon
  user_icon="$(get_tmux_option "@catppuccin_user_icon" "")"
  readonly user_icon

  local host
  host="$(get_tmux_option "@catppuccin_host" "off")"
  readonly host

  local directory_icon
  directory_icon="$(get_tmux_option "@catppuccin_directory_icon" "")"
  readonly directory_icon

  local window_icon
  window_icon="$(get_tmux_option "@catppuccin_window_icon" "")"
  readonly window_icon

  local session_icon
  session_icon="$(get_tmux_option "@catppuccin_session_icon" "")"
  readonly session_icon

  local host_icon
  host_icon="$(get_tmux_option "@catppuccin_host_icon" "󰒋")"
  readonly host_icon

  local date_time
  date_time="$(get_tmux_option "@catppuccin_date_time" "off")"
  readonly date_time

  local datetime_icon
  datetime_icon="$(get_tmux_option "@catppuccin_datetime_icon" "")"
  readonly datetime_icon

  # These variables are the defaults so that the setw and set calls are easier to parse.
  local show_directory
  readonly show_directory="#[fg=$thm_pink,bg=$thm_bg,nobold,nounderscore,noitalics]$right_separator#[fg=$thm_bg,bg=$thm_pink,nobold,nounderscore,noitalics]$directory_icon  #[fg=$thm_fg,bg=$thm_gray] #{b:pane_current_path} "

  local show_window
  readonly show_window="#[fg=$thm_pink,bg=$thm_bg,nobold,nounderscore,noitalics]$right_separator#[fg=$thm_bg,bg=$thm_pink,nobold,nounderscore,noitalics]$window_icon #[fg=$thm_fg,bg=$thm_gray] #W #{?client_prefix,#[fg=$thm_red]"

  # local show_session_1
  # readonly show_session_1="#{?#{==:#{b:pane_current_path}_#{pane_current_command},#S_zsh},#S,}"
  local show_session_2
  # readonly show_session_2="#{?#{!=:#{pane_current_command},zsh},#S,}"
  readonly show_session_2=" #S"
  # local show_dir
  # readonly show_dir="#{?#{!=:#{b:pane_current_path},#S},#{pane_current_path},}"
  local show_session
  # readonly show_session="#{?client_prefix,#[fg=$thm_red],#[fg=$thm_green]}#[bg=$thm_bg] #S #{?client_prefix,#[fg=$thm_red],#[fg=$thm_green]}#[bg=$thm_gray]$right_separator#{?client_prefix,#[bg=$thm_red],#[bg=$thm_green]}#[fg=$thm_bg]$session_icon "
  readonly show_session="#{?client_prefix,#[fg=1],#[fg=5]}#[bg=default,nobold]$show_session_2"

  local show_directory_in_window_status
  readonly show_directory_in_window_status="#[fg=$thm_bg,bg=$thm_blue] #I #[fg=$thm_fg,bg=$thm_gray] #{b:pane_current_path} "

  local show_directory_in_window_status_current
  readonly show_directory_in_window_status_current="#[fg=$thm_bg,bg=$thm_orange] #I #[fg=$thm_fg,bg=$thm_bg] #{b:pane_current_path} "

  local show_window_in_window_status
  # readonly show_window_in_window_status="#[fg=$thm_fg,bg=$thm_bg] #W #[fg=$thm_bg,bg=$thm_blue] #I#[fg=$thm_blue,bg=$thm_bg]$left_separator#[fg=$thm_fg,bg=$thm_bg,nobold,nounderscore,noitalics]"
  # readonly show_window_in_window_status="#[fg=$thm_black4,bg=$thm_bg] #I #W "
  readonly show_window_in_window_status="#[fg=$thm_black4,bg=default] ○ #{?#{==:#W,~/#S},zsh,#W} "
  # readonly show_window_in_window_status="#[fg=$thm_black4,bg=default] ○ #(tmux-win-title #{window_id}) "

  local show_window_in_window_status_current
  readonly show_window_in_window_status_current="#[fg=4,bg=default] ● #{?#{==:#W,~/#S},zsh,#W} "
  # readonly show_window_in_window_status_current="#[fg=$thm_orange,bg=$thm_gray] #W #[fg=$thm_bg,bg=$thm_orange] #I#[fg=$thm_orange,bg=$thm_bg]$left_separator#[fg=$thm_fg,bg=$thm_bg,nobold,nounderscore,noitalics]"
  # readonly show_window_in_window_status_current="#[fg=4,bg=default] ● #(tmux-win-title #{window_id}) "

  local show_user
  readonly show_user="#[fg=$thm_blue,bg=$thm_gray]$right_separator#[fg=$thm_bg,bg=$thm_blue]$user_icon #[fg=$thm_fg,bg=$thm_gray] #(whoami) "

  local show_host
  readonly show_host="#[fg=$thm_blue,bg=$thm_gray]$right_separator#[fg=$thm_bg,bg=$thm_blue]$host_icon #[fg=$thm_fg,bg=$thm_gray] #H "

  local show_date_time
  readonly show_date_time="#[fg=$thm_blue,bg=$thm_gray]$right_separator#[fg=$thm_bg,bg=$thm_blue]$datetime_icon #[fg=$thm_fg,bg=$thm_gray] $date_time "

  # Right column 1 by default shows the Window name.
  local right_column1=$show_window
  local show_git_branch
  # readonly show_git_branch="#[fg=$thm_pink,bg=$thm_bg,nobold,nounderscore,noitalics]#{?#{!=:#{pane_current_command},zsh},  #(git branch --show-current) ,}"
  readonly show_git_branch="#[fg=6,bg=default,nobold,nounderscore,noitalics]  #(git branch --show-current)"

  window_status_format=$show_window_in_window_status
  window_status_current_format=$show_window_in_window_status_current

  local in_copy_mode
  readonly in_copy_mode="#[bg=3,fg=${thm_bg},bold]#{?#{==:#{pane_mode},copy-mode}, COPY ,}"
  
  local in_view_mode
  readonly in_view_mode="#[bg=3,fg=${thm_bg},bold]#{?#{==:#{pane_mode},view-mode}, VIEW ,}"

  local in_prefix_mode
  readonly in_prefix_mode="#[bg=1,fg=${thm_bg},bold]#{?client_prefix, PREFIX ,}"

  tmux bind-key -T prefix ':' "command-prompt -F -p \"#[bg=${thm_cyan}]#[fg=${thm_bg}]#[bold] TMUX CMD #[nobold]#[bg=${thm_gray}]#[fg=${thm_cyan}]:\""
  # tmux bind-key -T prefix ':' "command-prompt -F -p \"#[bg=${thm_cyan}]HELLO\""
  local cal_next
  readonly cal_next="#[fg=${thm_fg}]#(gcal tmux --icon-only --popup)"

  local current_dir
  readonly current_dir="#[fg=${thm_orange},bg=default,nobold]#(tmux-dir)"

  local show_time
  readonly show_time="#[fg=2,italics]#(date +\"%a %b %d\") #[default,fg=4,bold]#(date +\"%H:%M\")"

  local show_gitmux
  # readonly show_gitmux='#(/Users/murtaza/go/gitmux "#{pane_current_path}")'
  readonly show_gitmux=' #(/Users/murtaza/go/bin/gitmux -cfg ~/dotfiles/gitmux.yaml "#{pane_current_path}")'

  local show_batt
  readonly show_batt='#(tmux-batt)'

  set status-left "${in_copy_mode}${in_prefix_mode}${in_view_mode}${current_dir}${show_gitmux}"

  set status-right "${show_time}${cal_next} ${show_batt}"

  setw window-status-format "${window_status_format}"
  setw window-status-current-format "${window_status_current_format}"

  # --------=== Modes
  #
  setw clock-mode-colour "${thm_blue}"
  setw mode-style "fg=${thm_pink} bg=${thm_black4} bold"

  tmux "${tmux_commands[@]}"
}

main "$@"
