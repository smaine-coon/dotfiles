local wezterm = require("wezterm")
local utils = require("utils")

local act = wezterm.action

-- you must disable the default keybindings to enable this custom event
wezterm.on("toggle_zen_mode", function(window, pane)
  local zen_key = 'ZEN' .. tostring(window:window_id())
  local current = utils.cache.global_cache:get(zen_key) or false
  utils.cache.global_cache:set(zen_key, not current)

  local overrides = window:get_config_overrides() or {}
  if not overrides.keys or not overrides.key_tables then
    overrides.keys = {
      {
        key = "z",
        mods = "CTRL",
        action = act.EmitEvent("toggle_zen_mode")
      },
    }
    overrides.key_tables = {}
  else
    overrides.keys = nil
    overrides.key_tables = nil
  end
  window:set_config_overrides(overrides)
end)

local config = {}

config.leader = { key = '.', mods = 'CTRL', timeout_milliseconds = 1500 }

config.keys = {
  -- workspace
  {
    key = "s",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "(wezterm) Create new workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = "s",
    mods = "LEADER|SHIFT",
    action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
  },
  {
    key = "F2",
    mods = "NONE",
    action = act.PromptInputLine({
      description = "(wezterm) Set workspace title:",
      action = wezterm.action_callback(function(win, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  -- window
  { key = "m", mods = "CTRL", action = act.Hide },
  { key = "n", mods = "CTRL", action = act.SpawnWindow },
  { key = "d", mods = "CTRL", action = act.ScrollByPage(0.5) },
  { key = "u", mods = "CTRL", action = act.ScrollByPage(-0.5) },
  -- tab
  { key = "t", mods = "SHIFT|CTRL", action = act({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "w", mods = "SHIFT|CTRL", action = act({ CloseCurrentTab = { confirm = true } }) },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "SHIFT|CTRL", action = act({ MoveTabRelative = 1 }) },
  { key = "[", mods = "SHIFT|CTRL", action = act({ MoveTabRelative = -1 }) },
  -- pane
  { key = "v", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  -- key tables
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
  },
  -- events
  {
    key = "z",
    mods = "CTRL",
    action = act.EmitEvent("toggle_zen_mode")
  },
  -- font
  { key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
  -- copy and paste
  { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  -- misc
  { key = "Enter", mods = "CTRL", action = act.ToggleFullScreen },
  { key = "l", mods = "CTRL", action = act.ClearScrollback("ScrollbackAndViewport") },
  { key = "p", mods = "CTRL", action = act.ActivateCommandPalette },
  { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
  { key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay},
}

config.key_tables = {
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "Enter", action = "PopKeyTable" },
  },
  activate_pane = {
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    { key = "j", action = act.ActivatePaneDirection("Down") },
  },
  copy_mode = {
    -- movement
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    { key = "g", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
    -- jump
    { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
    { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = "t", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "f", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    -- scroll
    { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
    { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
    { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
    -- mode
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    { key = "v", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    -- copy
    { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },
    -- quit
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    { key = "c", mods = "CTRL", action =  act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }), },
  },
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor("Cell"),
  },
  {
    event = { Down = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor("Word"),
  },
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor("Line"),
  },
  {
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.ExtendSelectionToMouseCursor("Cell"),
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom("PrimarySelection"),
  },
}

return config