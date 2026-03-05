local wezterm = require("wezterm")
local colors = require("colors")
local utils = require("utils")

local LEFT_DECORATION = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_DECORATION = wezterm.nerdfonts.ple_right_half_circle_thick
local ZOOMED = wezterm.nerdfonts.oct_zoom_in

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local palette = colors.get_color_palette(colors.get_appearance())
  local bg = palette.bg
  local fg = palette.fg
  local edge_bg = "none"
  local edge_fg = bg

  if tab.is_active then
    bg = colors.invert_hex_color(bg)
    fg = colors.invert_hex_color(fg)
    edge_fg = colors.invert_hex_color(edge_fg)
  end

  return {
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = LEFT_DECORATION },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = tab.active_pane.is_zoomed and ZOOMED or "" },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = wezterm.truncate_right(utils.format.basename(tab.active_pane.title), max_width - 1) },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = RIGHT_DECORATION },
}
end)

local config = {}

config.show_new_tab_button_in_tab_bar = false
-- this option is only available in nightly build
config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
config.window_background_gradient = {
  colors = { colors.get_color_palette(colors.get_appearance()).bg },
}

return config