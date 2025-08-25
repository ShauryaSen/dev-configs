local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Ayu Mirage"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 19
config.term = "xterm-256color"
config.window_decorations = "TITLE | RESIZE"
return config
