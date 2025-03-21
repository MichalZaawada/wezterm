local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local platform = wezterm.target_triple

IS_WIN = platform == "x86_64-pc-windows-msvc"
IS_LINUX = platform == "x86_64-unknown-linux-gnu"
IS_MAC = platform == "aarch64-apple-darwin"

if IS_WIN then
	require("win")
	config.default_prog = {
		"C:\\Program Files\\PowerShell\\7\\pwsh.exe",
		"-NoLogo",
		"-ExecutionPolicy",
		"RemoteSigned",
	}
elseif IS_LINUX or IS_MAC then
	require("linux")
end

-- Debug
wezterm.on("update-right-status", function(window)
	local tab = window:active_tab()
	if tab == nil then
		return
	end

	local active_pane = window:active_pane()
	local panes = tab:panes()
	for index, pane in ipairs(panes) do
		wezterm.log_info("Pane " .. index .. ":")
		wezterm.log_info("  ID: " .. tostring(pane:pane_id()))
		wezterm.log_info("  Process: " .. tostring(pane:get_foreground_process_name()))
		wezterm.log_info("  Title: " .. tostring(pane:get_title()))
		wezterm.log_info("  Directory: " .. tostring(pane:get_current_working_dir()))
		wezterm.log_info("  Is Active: " .. tostring(pane:pane_id() == active_pane:pane_id()))
	end
end)

config.font_size = 13
config.tab_max_width = 50
-- config.window_background_opacity = 0.85
-- config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.status_update_interval = 1000
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.8,
}
config.prefer_egl = true

config.window_padding = {
	bottom = 0,
}

-- config.color_scheme = "Jellybeans (Gogh)"
config.colors = {
	foreground = "#ffffff",
	background = "#121212",

	cursor_bg = "#ffffff",
	cursor_fg = "#121212",
	cursor_border = "#ffffff",

	selection_fg = "#ffffff",
	selection_bg = "#3c4048",

	scrollbar_thumb = "#121212",
	split = "#121212",

	ansi = { "#16181a", "#ff6e5e", "#5eff6c", "#f1ff5e", "#5ea1ff", "#bd5eff", "#5ef1ff", "#ffffff" },
	brights = { "#3c4048", "#ff6e5e", "#5eff6c", "#f1ff5e", "#5ea1ff", "#bd5eff", "#5ef1ff", "#ffffff" },
	indexed = { [16] = "#ffbd5e", [17] = "#ff6e5e" },
	tab_bar = {
		background = "#202020",
		new_tab = {
			bg_color = "#202020",
			fg_color = "#808080",
		},
		active_tab = {
			-- underline = "Single",
			bg_color = "#121212",
			fg_color = "#FFFFFF",
		},
		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = false,
		},
		inactive_tab = {
			bg_color = "#202020",
			fg_color = "#909090",
		},
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = false,
		},
	},
}
config.font = wezterm.font_with_fallback({
	{ family = "Iosevka Nerd Font Mono" },
	{ family = "JetBrains Mono" },
})

config.leader = { key = " ", mods = "CTRL" }
config.keys = {
	-- paste from the clipboard
	-- { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- { key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
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
	{ key = "l", mods = "LEADER", action = act.ShowDebugOverlay },
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
	local stat = window:active_workspace()

	if window:active_key_table() then
		stat = window:active_key_table()
	elseif window:leader_is_active() then
		stat = "leader"
	end

	-- Time
	-- local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		-- { Text = wezterm.nerdfonts.md_clock .. " " .. time },
		-- { Text = " | " },
		{ Text = wezterm.nerdfonts.oct_table .. " " .. stat },
	}))
end)

return config
