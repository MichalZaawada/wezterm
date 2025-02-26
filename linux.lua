local wezterm = require("wezterm")

local basename = function(s)
	return string.gsub(s:sub(1, -2), "(.*[/\\])(.*)", "%2")
end
local tab_title = function(tab_info)
	local active_pane = tab_info.active_pane
	local current_dir = basename(tostring(active_pane.current_working_dir))

	local active_procces = active_pane.foreground_process_name
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
	elseif string.find(active_procces, "node") then
		icon = wezterm.nerdfonts.dev_nodejs_small
		text_color = "#43853D"
	elseif string.find(active_procces, "net") then
		icon = wezterm.nerdfonts.md_dot_net
		text_color = "#512BD4"
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
