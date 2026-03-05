local utils = require("utils")

local default_shell = {
  windows = { "powershell.exe" },
  macos = { "zsh" },
  linux = { "bash" },
}

local function detect_shell()
  if utils.platform.is_wsl or utils.platform.is_linux then
    return default_shell.linux
  elseif utils.platform.is_windows then
    return default_shell.windows
  elseif utils.platform.is_macos then
    return default_shell.macos
  else
    return { "bash" }
  end
end

local config = {}

config.default_prog = detect_shell()

return config