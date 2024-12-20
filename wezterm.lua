local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local platform = wezterm.target_triple

if platform == "x86_64-pc-windows-msvc" then
	config.default_prog = {
		"C:\\Program Files\\PowerShell\\7\\pwsh.exe",
		"-NoLogo",
		"-ExecutionPolicy",
		"RemoteSigned",
	}
end

-- wezterm.on("update-right-status", function(window)
-- 	local tab = window:active_tab()
-- 	if tab == nil then
-- 		return
-- 	end
--
-- 	local active_pane = window:active_pane()
-- 	local panes = tab:panes()
-- 	for index, pane in ipairs(panes) do
-- 		wezterm.log_info("Pane " .. index .. ":")
-- 		wezterm.log_info("  ID: " .. tostring(pane:pane_id()))
-- 		wezterm.log_info("  Process: " .. tostring(pane:get_foreground_process_name()))
-- 		wezterm.log_info("  Title: " .. tostring(pane:get_title()))
-- 		wezterm.log_info("  Directory: " .. tostring(pane:get_current_working_dir()))
-- 		wezterm.log_info("  Is Active: " .. tostring(pane:pane_id() == active_pane:pane_id()))
-- 	end
-- end)

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

config.color_scheme = "Jellybeans (Gogh)"
config.colors = {
	tab_bar = {
		background = "#202020",
		new_tab = {
			bg_color = "#202020",
			fg_color = "#808080",
		},
		active_tab = {
			-- underline = "Single",
			bg_color = "#000000",
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
	end
	if window:leader_is_active() then
		stat = "leader"
	end

	-- Time
	-- local time = wezterm.strftime("%H:%M")

	-- Let's add color to one of the components
	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.oct_table .. " " .. stat },
		-- { Text = " | " },
		-- { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		-- { Text = " |" },
	}))
end)

local basename = function(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local tab_title = function(tab_info)
	local active_pane = tab_info.active_pane
	local current_dir = basename(tostring(active_pane.current_working_dir))

	local tab_title = string.lower(active_pane.title)
	local tab_index = tostring(tab_info.tab_index + 1)
	local icon = wezterm.nerdfonts.cod_terminal
	local text_color = "White"

	if string.find(tab_title, "nvim") then
		icon = wezterm.nerdfonts.custom_neovim
		text_color = "#4ADE80"
	elseif string.find(tab_title, "lazygit") then
		icon = wezterm.nerdfonts.fa_git
		text_color = "#F05033"
	end

	if tab_index and #tab_index > 0 then
		return " " .. tab_index .. ": " .. current_dir .. " " .. icon .. " ", text_color
	end

	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local title, text_color = tab_title(tab)
	if tab.is_active then
		return {
			-- { Background = { Color = "866CBA" } },
			{ Foreground = { Color = text_color } },
			{ Text = title },
		}
	end
	return title
end)

return config
