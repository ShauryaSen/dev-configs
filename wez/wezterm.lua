local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Catppuccin Macchiato" -- or Macchiato, Frappe, Latte

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 19
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10

-- and finally, return the configuration to wezterm
return config
