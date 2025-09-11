#!/usr/bin/env python3

import subprocess
import sys

class MochaColors:
    background = '#1e1e2e'
    color0 = '#1e1e2e'
    red = '#f38ba8'
    color1 = '#f38ba8'
    yellow = '#f9e2af'
    color2 = '#f9e2af'
    green = '#a6e3a1'
    color3 = '#a6e3a1'
    blue = '#89b4fa'
    color4 = '#89b4fa'
    magenta = '#cba6f7'
    color5 = '#cba6f7'
    cyan = '#94e2d5'
    color6 = '#94e2d5'
    foreground = '#cdd6f4'
    text = '#cdd6f4'
    color7 = '#cdd6f4'

    # subtext1 = '#bac2de'
    # subtext0 = '#a6adc8'
    surface5 = '#9399b2'
    surface4 = '#7f849c'
    surface3 = '#6c7086'
    surface2 = '#585b70'
    surface1 = '#45475a'
    surface0 = '#313244'

try:
    from murtaza.walcolors import colors
    colors = colors
except ImportError:
    print("Warning: pywal colors not found")
    colors = MochaColors()

def build_window_icon():
    """Build dynamic window icon string"""
    # Window name to icon mappings
    window_icons = {
        "zsh": "",
        "nvim": "",
        "claude": "󰧑",
        "docker": "󰡨",
        "./run.sh": "",
        "ssh": "",
        "man": "",
        "aws": "󰸏",
    }

    # Regex patterns
    regex_patterns = {
        "python3?|uv": "",
        "btop|htop|top": "",
        "git|gd|gcamp|gcmp|gcm|gcam|gs|gl": "",
    }
    
    # Build conditionals
    conditionals = []
    
    # Add exact matches
    for window, icon in window_icons.items():
        conditionals.append(f"#{{?#{{==:#W,{window}}},{icon}")
    
    # Add regex matches
    for pattern, icon in regex_patterns.items():
        conditionals.append(f"#{{?#{{m/r:#W,{pattern}}},{icon}")
    
    # Combine with proper closing braces
    window_icon = ",".join(conditionals)
    closing_braces = "}" * len(conditionals)
    window_icon = f"{window_icon},#W{closing_braces} "
    # print(f"Built window icon format: {window_icon}")
    
    return window_icon

def apply_theme():
    """Apply tmux theme by accumulating commands and running in single subprocess call"""
    commands = []
    
    def set_(option, value):
        commands.extend(['set-option', '-gq', option, value, ';'])
    
    def setw(option, value):
        commands.extend(['set-window-option', '-gq', option, value, ';'])
    
    # Status bar
    set_('status-position', 'bottom')
    set_('status', 'on')
    set_('status-bg', 'default')
    set_('status-style', 'bg=default')
    setw('window-status-style', 'bg=default')
    set_('status-justify', 'absolute-centre')
    set_('status-left-length', '100')
    set_('status-right-length', '100')
    
    # Status content components
    in_copy_mode = f"#[bg=3,fg={colors.background},bold]#{{?#{{==:#{{pane_mode}},copy-mode}}, COPY ,}}"
    in_view_mode = f"#[bg=3,fg={colors.background},bold]#{{?#{{==:#{{pane_mode}},view-mode}}, VIEW ,}}"
    in_prefix_mode = f"#[bg=1,fg={colors.background},bold]#{{?client_prefix, PREFIX ,}}"
    
    cal_next = f"#[fg={colors.foreground}]#(gcal tmux --icon-only --popup)"
    
    session_and_dir = f"#[bg=default]#(tmux-dir)"
    
    show_time = f"#[fg={colors.color3},italics]#(date +\"%a %b %d\") #[default,fg={colors.color4},bold]#(date +\"%H:%M\")"
    
    show_gitmux = ' #(gitmux -cfg ~/dotfiles/gitmux.yaml "#{pane_current_path}")'
    
    show_batt = '#(tmux-batt)'
    
    show_docker = '#[fg=6]#(docker-container-count)'
    
    # Set status left and right
    status_left = f"{in_copy_mode}{in_prefix_mode}{in_view_mode}{session_and_dir}{show_gitmux} {cal_next}"
    status_right = f"{show_docker} {show_time} {show_batt}"
    
    set_('status-left', status_left)
    set_('status-right', status_right)
    
    # Messages
    set_('message-style', f"fg={colors.cyan},bg={colors.surface0},align=centre")
    set_('message-command-style', f"fg={colors.cyan},bg={colors.surface0},align=centre")
    
    # Panes
    set_('pane-border-style', f"fg={colors.surface2}")
    set_('pane-active-border-style', "fg=4")
    
    # Windows
    setw('window-status-activity-style', f"fg={colors.foreground},bg={colors.background},none")
    setw('window-status-separator', '')
    
    # Build dynamic window icon
    window_icon = build_window_icon()
    
    # Window formats
    window_format = f"#[fg={colors.surface2},bg=default] {window_icon}"

    current_window_format = f"#[fg={colors.color1},bg=default] {window_icon}"
    
    setw('window-status-format', window_format)
    setw('window-status-current-format', current_window_format)
    
    # Modes
    setw('clock-mode-colour', colors.blue)
    setw('mode-style', f"fg={colors.color5} bg={colors.surface2} bold")
    
    # Execute all commands in single subprocess call
    # print(commands)
    subprocess.run(['tmux'] + commands, check=True)
    # print("Tmux theme applied successfully!")

def main():
    """Main function"""
    try:
        apply_theme()
    except subprocess.CalledProcessError as e:
        print(f"Error running tmux command: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
