--------------------
---- WORKSPACES ----
--------------------

local programs = require("modules.programs")
local uwsm = require("lib.uwsm")
local workspaceMap = require("lib.workspace_map")
local plugin = require("lib.plugin")

-- See https://hyprexpo.lol/docs/

if plugin.is_loaded("hyprexpo") then
	hl.config({
		plugin = {
			hyprexpo = {
				columns = 3,
				gaps_in = 0,
				gaps_out = 10,
				--bg_col = "rgb(111111)",
				wallpaper_bg = 1,
				border_width = 1,
				border_color_focus = "",
				border_color_current = "",
				workspace_method = "first 1",
				max_workspace = 9,
				label_text_mode = "token",
				label_token_map = workspaceMap.hyprexpo_labels(9),
				label_position = "bottom-left",
				label_font_size = 20,
				label_bg_shape = "rounded",
				show_workspace_numbers = 0,
				number_key_mode = "passthrough",
				gesture_distance = 200,
				cancel_key = "escape",
				show_cursor = 1,
			},
		},
	})
end

local M = {}

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

---------------------
---- WORKSPACE 1 ----
---------------------
hl.workspace_rule({
	default_name = "1 Code 1",
	workspace = workspaceMap.selector(1),
	persistent = true,
})
local function setup_workspace_1()
	-- Programs to launch
end

---------------------
---- WORKSPACE 2 ----
---------------------
hl.workspace_rule({
	default_name = "2 Code 2",
	workspace = workspaceMap.selector(2),
	persistent = true,
})
local function setup_workspace_2()
	-- Programs to launch
end

---------------------
---- WORKSPACE 3 ----
---------------------
hl.workspace_rule({
	default_name = "3 Code 3",
	workspace = workspaceMap.selector(3),
	persistent = true,
})
local function setup_workspace_3()
	-- Programs to launch
end

---------------------
---- WORKSPACE 4 ----
---------------------
hl.workspace_rule({
	default_name = "4 Discord",
	workspace = workspaceMap.selector(4),
	persistent = true,
})
local function setup_workspace_4()
	-- Programs to launch
end

-------------------------------
---- WORKSPACE 5 - BROWSER ----
-------------------------------
hl.workspace_rule({
	default_name = "5 Browser",
	workspace = workspaceMap.selector(5),
	persistent = true,
	default = true,
})
local function setup_workspace_5()
	-- Make default
	hl.dispatch(hl.dsp.focus({ workspace = workspaceMap.physical(5) }))
	-- Programs to launch
	uwsm.start_with_rules(programs.browser, "firefox", { workspace = workspaceMap.selector(5, "silent") })
end

---------------------
---- WORKSPACE 6 ----
---------------------
hl.workspace_rule({
	default_name = "6 Steam",
	workspace = workspaceMap.selector(6),
	persistent = true,
})
local function setup_workspace_6()
	-- Programs to launch
end

---------------------
---- WORKSPACE 7 ----
---------------------
hl.workspace_rule({
	default_name = "7",
	workspace = workspaceMap.selector(7),
	persistent = true,
})
local function setup_workspace_7()
	-- Programs to launch
end

-----------------------------
---- WORKSPACE 8 - NOTES ----
-----------------------------
hl.workspace_rule({
	default_name = "8 Notes",
	workspace = workspaceMap.selector(8),
	persistent = true,
})
local function setup_workspace_8()
	-- Programs to launch
	uwsm.start_with_rules(programs.notes, "obsidian", {
		workspace = workspaceMap.selector(8, "silent"),
		render_unfocused = true,
	})
end

-----------------------------
---- WORKSPACE 9 - MUSIC ----
-----------------------------
hl.workspace_rule({
	default_name = "9 Music",
	workspace = workspaceMap.selector(9),
	persistent = true,
})

hl.window_rule({
	name = "tidal-workspace",
	match = {
		class = "^com\\.mastermindzh\\.tidal-hifi$",
	},

	workspace = workspaceMap.selector(9, "silent"),
	render_unfocused = true,
})

local function setup_workspace_9()
	uwsm.start(programs.music, "tidal")
end

function M.setup_workspaces()
	setup_workspace_1()
	setup_workspace_2()
	setup_workspace_3()
	setup_workspace_4()
	setup_workspace_5()
	setup_workspace_6()
	setup_workspace_7()
	setup_workspace_8()
	setup_workspace_9()
end

return M
