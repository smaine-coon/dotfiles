local wezterm = require("wezterm")
local utils = require("utils")

local s_size = 10
local l_size = 12

local font_family = {
  user = { "Firge35Nerd Console" },
  windows = { "Consolas" },
  macos = { "San Francisco" },
  linux = { "DejaVu Sans" },
  wez = { "JetBrains Mono", "Noto Color Emoji" },
}

local function get_font()
  local tmp = {}
  local re = {}

  table.insert(tmp, font_family.user)
  if utils.platform.is_wsl or utils.platform.is_linux then
    table.insert(tmp, font_family.linux)
  elseif utils.platform.is_windows then
    table.insert(tmp, font_family.windows)
  elseif utils.platform.is_macos then
    table.insert(tmp, font_family.macos)
  end
  table.insert(tmp, font_family.wez)

  for _, v in ipairs(tmp) do
    for _, font in ipairs(v) do
      table.insert(re, font)
    end
  end

  return re
end

local config = {}

config.font_size = l_size
config.line_height = 1.1
config.font = wezterm.font_with_fallback(get_font())

return config