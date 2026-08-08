----------------
---- LAYOUT ----
----------------

local layoutGrid = require("lib.layout-grid")

-- Tiled window boundaries snap to these fractions of the monitor work area.
-- Change these three values to tune the grid in one place.
local grid = layoutGrid.create({
	grid_width = 12,
	grid_height = 8,
	initial_master_width = 8,
})

hl.config({
	general = {
		layout = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		mfact = grid.initial_master_factor,
		new_status = "slave",
		orientation = "left",
		focus_master_on_close = false,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

return {
	grid = grid,
}
