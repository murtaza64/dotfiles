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
  # shellcheck source=tmux/catppuccin-frappe.tmuxtheme
  source /dev/stdin <<<"$(sed -e "/^[^#].*=/s/^/local /" "${PLUGIN_DIR}/catppuccin-${theme}.tmuxtheme")"

  # status
  
  # shellcheck disable=SC2121
  set status "on" 
  set status-position "bottom"
  set status-justify "absolute-centre"
  set status-left-length "100"
  set status-right-length "100"
  # default is transparent
  set status-bg default
  setw window-status-style bg=default
  set status-style bg=default

  local in_copy_mode="#[bg=3,fg=${thm_bg},bold]#{?#{==:#{pane_mode},copy-mode}, COPY ,}"
  local in_view_mode="#[bg=3,fg=${thm_bg},bold]#{?#{==:#{pane_mode},view-mode}, VIEW ,}"
  local in_prefix_mode="#[bg=1,fg=${thm_bg},bold]#{?client_prefix, PREFIX ,}"

  local cal_next="#[fg=${thm_fg}]#(gcal tmux --icon-only --popup)"

  local session_and_dir="#[fg=${thm_orange},bg=default,nobold]#(tmux-dir)"

  local show_time="#[fg=2,italics]#(date +\"%a %b %d\") #[default,fg=4,bold]#(date +\"%H:%M\")"

  local show_gitmux=' #(gitmux -cfg ~/dotfiles/gitmux.yaml "#{pane_current_path}")'

  local show_batt='#(tmux-batt)'

  set status-left "${in_copy_mode}${in_prefix_mode}${in_view_mode}${session_and_dir}${show_gitmux} ${cal_next}"
  set status-right "${show_time} ${show_batt}"

  # messages
  set message-style "fg=${thm_cyan},bg=${thm_gray},align=centre"
  set message-command-style "fg=${thm_cyan},bg=${thm_gray},align=centre"

  # panes
  set pane-border-style "fg=${thm_black4}"
  set pane-active-border-style "fg=4"

  # windows
  setw window-status-activity-style "fg=${thm_fg},bg=${thm_bg},none"
  setw window-status-separator ""

  local window="#[fg=$thm_black4,bg=default] #{?#{==:#W,zsh}, ,#{?#{==:#W,},#W,  #W}} "
  local current_window="#[fg=4,bg=default] #{?#{==:#W,zsh}, ,#{?#{==:#W,},#W,  #W}} "
  setw window-status-format "${window}"
  setw window-status-current-format "${current_window}"

  # modes
  setw clock-mode-colour "${thm_blue}"
  setw mode-style "fg=${thm_pink} bg=${thm_black4} bold"

  tmux "${tmux_commands[@]}"
}

main "$@"
