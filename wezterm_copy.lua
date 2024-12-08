-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

-- config.color_scheme = "Jellybeans"
-- config.color_scheme = "Papercolor Dark"
-- config.color_scheme = "Papercolor Dark (Gogh)"
config.color_scheme = "Jellybeans (Gogh)"

-- config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font = wezterm.font_with_fallback({
	{ family = "Iosevka Nerd Font Mono" },
	{ family = "JetBrains Mono" },
})
config.font_size = 13

-- config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.leader = { key = " ", mods = "CTRL" }
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.8,
}
config.prefer_egl = true

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" }
end
config.keys = {
	-- paste from the clipboard
	-- { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- { key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "a", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
	{ key = "c", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },

	-- pane
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "y", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },
	{ key = "r", mods = "CTRL|SHIFT", action = act.RotatePanes("Clockwise") },
	-- navigation
	{ key = "e", mods = "CTRL|SHIFT", action = act.ShowTabNavigator },
	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
	-- { key = "a", mods = "CTRL|SHIFT", action = act.PaneSelect({ alphabet = "1234567890" }) },

	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "movement_pane", one_shot = false }) },
	-- { key = "e", mods = "LEADER", action = act.ShowTabNavigator },
	-- { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	-- { key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	movement_pane = {
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

wezterm.on("update-right-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() then
		stat = window:active_key_table()
	end
	if window:leader_is_active() then
		stat = "leader"
	end

	-- Current working directory
	-- local basename = function(s)
	-- 	return string.gsub(s, "(.*[/\\])(.*)", "%2")
	-- end

	-- wezterm.log_info(pane:get_current_working_dir())
	-- basename()
	-- local cwd = pane:get_current_working_dir()
	-- Current command
	-- local cmd = basename(pane:get_foreground_process_name())

	-- Time
	-- local time = wezterm.strftime("%H:%M")

	-- Let's add color to one of the components
	window:set_right_status(wezterm.format({
		-- Wezterm has a built-in nerd fonts
		{ Text = wezterm.nerdfonts.oct_table .. " " .. stat },
		-- { Text = " | " },
		-- { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		-- { Text = " | " },
		-- { Foreground = { Color = "FFB86C" } },
		-- { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		-- "ResetAttributes",
		-- { Text = " | " },
		-- { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		-- { Text = " |" },
	}))
end)

local function tab_title(tab_info)
	local title = tostring(tab_info.tab_index + 1)
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return " " .. title .. " "
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Background = { Color = "#866CBA" } },
			{ Text = title },
		}
	end
	return title
end)
return config
