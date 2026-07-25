------------------
---- WORKSPACES ----
------------------

local programs = require("modules.programs")
local uwsm = require("lib.uwsm")

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Workspace 1
hl.workspace_rule({
	workspace = "1",
	persistent = true,
})

-- Workspace 2
hl.workspace_rule({
	workspace = "2",
	persistent = true,
})

-- Workspace 3
hl.workspace_rule({
	workspace = "3",
	persistent = true,
})

-- Workspace 4
hl.workspace_rule({
	workspace = "4",
	persistent = true,
})

-- Workspace 5: Firefox
hl.workspace_rule({
	workspace = "5",
	persistent = true,
})

hl.window_rule({
	name = "firefox-workspace",
	match = { class = "firefox" },

	workspace = "5",
})

-- Workspace 6
hl.workspace_rule({
	workspace = "6",
	persistent = true,
})

-- Workspace 7
hl.workspace_rule({
	workspace = "7",
	persistent = true,
})

-- Workspace 8: Obsidian
hl.workspace_rule({
	workspace = "8",
	persistent = true,
})

hl.window_rule({
	name = "obsidian-workspace",
	match = { class = "[Oo]bsidian" },

	workspace = "8",
})

-- Workspace 9
hl.workspace_rule({
	workspace = "9",
	persistent = true,
})

hl.on("hyprland.start", function()
	uwsm.start(programs.browser, "firefox")
	uwsm.start("obsidian", "obsidian")
end)
