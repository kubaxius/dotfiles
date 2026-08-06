--------------------
---- WORKSPACES ----
--------------------

local programs = require("modules.programs")
local uwsm = require("lib.uwsm")

local M = {}

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

---------------------
---- WORKSPACE 1 ----
---------------------
hl.workspace_rule({
	default_name = "Code 1",
	workspace = "1",
	persistent = true,
})
local function setup_workspace_1()
	-- Programs to launch
end

---------------------
---- WORKSPACE 2 ----
---------------------
hl.workspace_rule({
	default_name = "Code 2",
	workspace = "2",
	persistent = true,
})
local function setup_workspace_2()
	-- Programs to launch
end

---------------------
---- WORKSPACE 3 ----
---------------------
hl.workspace_rule({
	default_name = "Code 3",
	workspace = "3",
	persistent = true,
})
local function setup_workspace_3()
	-- Programs to launch
end

---------------------
---- WORKSPACE 4 ----
---------------------
hl.workspace_rule({
	default_name = "Discord",
	workspace = "4",
	persistent = true,
})
local function setup_workspace_4()
	-- Programs to launch
end

-------------------------------
---- WORKSPACE 5 - BROWSER ----
-------------------------------
hl.workspace_rule({
	default_name = "Browser",
	workspace = "5",
	persistent = true,
	default = true,
})
local function setup_workspace_5()
	-- Make default
	hl.dispatch(hl.dsp.focus({ workspace = 5 }))
	-- Programs to launch
	uwsm.start_with_rules(programs.browser, "firefox", { workspace = "5 silent" })
end

---------------------
---- WORKSPACE 6 ----
---------------------
hl.workspace_rule({
	default_name = "Steam",
	workspace = "6",
	persistent = true,
})
local function setup_workspace_6()
	-- Programs to launch
end

---------------------
---- WORKSPACE 7 ----
---------------------
hl.workspace_rule({
	workspace = "7",
	persistent = true,
})
local function setup_workspace_7()
	-- Programs to launch
end

-----------------------------
---- WORKSPACE 8 - NOTES ----
-----------------------------
hl.workspace_rule({
	default_name = "Notes",
	workspace = "8",
	persistent = true,
})
local function setup_workspace_8()
	-- Programs to launch
	uwsm.start_with_rules(programs.notes, "obsidian", { workspace = "8 silent", render_unfocused = true })
end

-----------------------------
---- WORKSPACE 9 - MUSIC ----
-----------------------------
hl.workspace_rule({
	default_name = "Music",
	workspace = "9",
	persistent = true,
})

hl.window_rule({
	name = "tidal-workspace",
	match = {
		class = "^com\\.mastermindzh\\.tidal-hifi$",
	},

	workspace = "9 silent",
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
