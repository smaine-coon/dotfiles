local wezterm = require("wezterm")
local target = wezterm.target_triple

local M = {}

M.is_wsl = wezterm.running_under_wsl()
M.is_windows = target:find("windows") ~= nil
M.is_macos = target:find("darwin") ~= nil
M.is_linux = target:find("linux") ~= nil and not M.is_wsl

return M