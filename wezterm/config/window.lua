local wezterm = require("wezterm")
local colors = require("colors")
local utils = require("utils")

local function poll_bg(window)
  local new_color_scheme = colors.get_color_scheme(colors.get_appearance())
  if window:effective_config().color_scheme ~= new_color_scheme then
    local overrides = window:get_config_overrides() or {}
    overrides.color_scheme = new_color_scheme
    window:set_config_overrides(overrides)
  end
  wezterm.time.call_after(2, function()
    poll_bg(window)
  end)
end

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window = window:gui_window()
  window:maximize()
  poll_bg(window)
end)

wezterm.on("format-window-title", function(tab)
  return utils.format.basename(tab.active_pane.foreground_process_name)
end)

local config = {}

config.color_scheme = colors.get_color_scheme(colors.get_appearance())
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- this option is only available in nightly build
config.window_content_alignment = {
  horizontal = "Center",
  vertical = "Center",
}
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.window_background_opacity = 0.85

return config