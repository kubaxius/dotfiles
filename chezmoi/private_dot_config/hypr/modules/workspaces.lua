------------------
---- WORKSPACES ----
------------------

local programs = require("modules.programs")

local M = {}

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

-- Workspace 9
hl.workspace_rule({
	workspace = "9",
	persistent = true,
})

function M.setup_workspaces()
	-- Hyprland one-shot rules need to track the real app process.
	-- Launch these directly so the startup-only workspace placement applies.
	hl.exec_cmd(programs.browser, { workspace = "5 silent" })
	hl.exec_cmd(programs.obsidian, { workspace = "8 silent" })
end

return M
