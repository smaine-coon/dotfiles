local wezterm = require("wezterm")

local default_theme = "classic"
local theme_file = wezterm.config_dir .. "/theme"

local M = {}

function M.switch_theme(new_color_scheme)
  local file = io.open(theme_file, "w")
  if file then
    file:write(new_color_scheme)
    file:close()
  end
end

function M.get_appearance()
  if wezterm.gui then
    local appearance = wezterm.gui.get_appearance()
    return string.find(appearance, "Light") and "light" or "dark"
  end
  return "dark"
end

function M.get_color_scheme(appearance)
  local i = appearance == "light" and 2 or 1

  local file = io.open(theme_file, "r")
  if file then
    local theme = file:read("*l")
    file:close()
    if theme and theme ~= "" then
      local ok, re = pcall(require, "colors." .. theme)
      if ok then
        return re.theme[i]
      end
    end
  end
  local mod = require("colors." .. default_theme)
  return mod.theme[i]
end

function M.get_color_palette(appearance)
  local i = appearance == "light" and 2 or 1

  local file = io.open(theme_file, "r")
  if file then
    local theme = file:read("*l")
    file:close()
    if theme and theme ~= "" then
      local ok, re = pcall(require, "colors." .. theme)
      if ok then
        return {
          fg =  re.fg[i],
          bg =  re.bg[i],
        }
      end
    end
  end
  local mod = require("colors." .. default_theme)
  return {
    fg =  mod.fg[i],
    bg =  mod.bg[i],
  }
end

function M.invert_hex_color(color)
  color = string.gsub(color, "#", "")

  local r = tonumber(string.sub(color, 1, 2), 16)
  local g = tonumber(string.sub(color, 3, 4), 16)
  local b = tonumber(string.sub(color, 5, 6), 16)

  local inverted_r = 255 - r
  local inverted_g = 255 - g
  local inverted_b = 255 - b

  return string.format("#%02x%02x%02x", inverted_r, inverted_g, inverted_b)
end

return M