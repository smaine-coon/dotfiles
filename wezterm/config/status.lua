local wezterm = require("wezterm")
local colors = require("colors")
local utils = require("utils")

local LEFT_DECORATION = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_DECORATION = wezterm.nerdfonts.ple_right_half_circle_thick
local BATTERY = wezterm.nerdfonts.md_battery
local CALENDAR = wezterm.nerdfonts.fa_calendar_o
local KEYBOARD = wezterm.nerdfonts.fa_keyboard
local LEADER = wezterm.nerdfonts.md_map_marker_alert
local ON = wezterm.nerdfonts.fa_toggle_on
local OFF = wezterm.nerdfonts.fa_toggle_off

local function add_decoration(elems, icon)
  local palette = colors.get_color_palette(colors.get_appearance())
  local bg = "none"
  local fg = palette.bg

  table.insert(elems, { Background = { Color = bg } })
  table.insert(elems, { Foreground = { Color = fg } })
  table.insert(elems, { Text = icon })
end

local function add_element(elems, icon, text)
  local palette = colors.get_color_palette(colors.get_appearance())
  local bg = palette.bg
  local fg = palette.fg

  table.insert(elems, { Background = { Color = bg } })
  table.insert(elems, { Foreground = { Color = fg } })
  table.insert(elems, { Text = " " .. icon .. "  " .. text .. " " })
end

local function get_battery(elems, window)
  for _, b in ipairs(wezterm.battery_info()) do
    add_element(elems, BATTERY, string.format("%.0f%%", b.state_of_charge * 100))
  end
end

local function get_date_and_time(elems)
  add_element(elems, CALENDAR, wezterm.strftime("%b %-d %H:%M"))
end

wezterm.on("update-status", function(window, pane)
  local zen_key = "ZEN" .. tostring(window:window_id())
  local is_zen = utils.cache.global_cache:get(zen_key)

  local elements = {}

  add_decoration(elements, LEFT_DECORATION)
  add_element(elements, window:leader_is_active() and LEADER or KEYBOARD, window:active_key_table()  or "  ? ")
  add_element(elements, is_zen and ON or OFF, "")
  get_date_and_time(elements)
  get_battery(elements, window)
  add_decoration(elements, RIGHT_DECORATION)

  window:set_right_status(wezterm.format(elements))
end)

local config = {}

config.status_update_interval = 1000

return config