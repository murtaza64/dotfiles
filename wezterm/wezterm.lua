local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.7
config.win32_system_backdrop = "Acrylic"

config.hide_tab_bar_if_only_one_tab = true

config.default_prog = {"wsl", "--", "cd", "$HOME", "&&", "tmux", "new", "-As0"}

config.keys = {
  {
    key = "l",
    mods = "ALT",
    action = wezterm.action.SendString("\x00\t")
  },
  {
    key = "h",
    mods = "ALT",
    action = wezterm.action.SendString("\x00\x1b[Z")
  },
  {
    key = "t",
    mods = "ALT",
    action = wezterm.action.SendString("\x00c")
  },
  {
    key = "s",
    mods = "ALT",
    action = wezterm.action.SendString("\x00s")
  },
}

return config
