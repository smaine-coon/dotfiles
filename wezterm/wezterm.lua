local wezterm = require("wezterm")
local utils = require("utils")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
  config:set_strict_mode(true)
end

local function merge_config(file)
  utils.tbl.merge_tables(config, require("config." .. file))
end

for _, v in ipairs(wezterm.glob(wezterm.config_dir .. "/config/*.lua")) do
  local file_name = utils.format.basename(v)
  merge_config(file_name:sub(1, #file_name - 4)) -- remove ".lua" from the file_name
end

return config