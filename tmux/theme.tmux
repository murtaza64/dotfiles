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
  
  local show_docker='#[fg=6]#(docker-container-count)'

  set status-left "${in_copy_mode}${in_prefix_mode}${in_view_mode}${session_and_dir}${show_gitmux} ${cal_next}"
  set status-right "${show_docker} ${show_time} ${show_batt}"

  # messages
  set message-style "fg=${thm_cyan},bg=${thm_gray},align=centre"
  set message-command-style "fg=${thm_cyan},bg=${thm_gray},align=centre"

  # panes
  set pane-border-style "fg=${thm_black4}"
  set pane-active-border-style "fg=4"

  # windows
  setw window-status-activity-style "fg=${thm_fg},bg=${thm_bg},none"
  setw window-status-separator ""

  # local -A window_icons=(
  #   "zsh" ""
  #   "nvim" ""
  #   "claude" "󰧑"
  #   "docker" "󰡨"
  #   "./run.sh" ""
  #   "ssh" ""
  # )
  #
  # # Define regex patterns separately
  # local -A regex_patterns=(
  #   "python3?|uv" ""
  # )
  #
  # # For window icons (key-value pairs)
  # for window in "${(@k)window_icons}"; do
  #   icon="${window_icons[$window]}"
  #   window_icon="${window_icon}#{?#{==:#W,$window},$icon,"
  # done
  #
  # # For regex patterns
  # for pattern in "${(@k)regex_patterns}"; do
  #   icon="${regex_patterns[$pattern]}"
  #   window_icon="${window_icon}#{?#{m/r:#W,$pattern},$icon,"
  # done
  #
  #
  # # Add default case and close conditionals
  # local num_conditions=$((${#window_icons} + ${#regex_patterns}))
  #   local closing_braces=""
  #   for ((i=1; i<=num_conditions; i++)); do
  #     closing_braces="${closing_braces}}"
  #   done
  #   window_icon="${window_icon}#W${closing_braces} "

  local zsh_icon="#{?#{==:#W,zsh},"
  local nvim_icon="#{?#{==:#W,},#W"
  local claude_icon="#{?#{==:#W,claude},󰧑"
  local docker_icon="#{?#{==:#W,docker},󰡨"
  local runsh_icon="#{?#{==:#W,./run.sh},"
  local python_icon="#{?#{m/r:#W,python3?|uv},"
  local ssh_icon="#{?#{==:#W,ssh},"
  local window_icon="${zsh_icon},${nvim_icon},${claude_icon},${docker_icon},${runsh_icon},${python_icon},  #W}}}}}} "
  local window_icon="#{?#{==:#W,zsh}, ,#{?#{==:#W,},#W,#{?#{==:#W,claude},󰧑,#{?#{==:#W,docker},󰡨,  #W}}}} "
  local window="#[fg=$thm_black4,bg=default] ${window_icon}"
  local current_window="#[fg=4,bg=default] ${window_icon}"
  setw window-status-format "${window}"
  setw window-status-current-format "${current_window}"

  # modes
  setw clock-mode-colour "${thm_blue}"
  setw mode-style "fg=${thm_pink} bg=${thm_black4} bold"

  tmux "${tmux_commands[@]}"
}

main "$@"
