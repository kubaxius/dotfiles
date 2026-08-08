---------------------
---- LAYOUT GRID ----
---------------------

-- Tiled window boundaries snap to these fractions of the monitor work area.
-- Change these three values to tune the grid in one place.
local grid = {
	grid_width = 12,
	grid_height = 8,
	initial_master_width = 8,
}

local function positiveInteger(name, value)
	if type(value) ~= "number" or value < 1 or value % 1 ~= 0 then
		error(name .. " must be a positive integer")
	end
end

positiveInteger("grid_width", grid.grid_width)
positiveInteger("grid_height", grid.grid_height)
positiveInteger("initial_master_width", grid.initial_master_width)

if grid.initial_master_width >= grid.grid_width then
	error("initial_master_width must be smaller than grid_width")
end

grid.initial_master_factor = grid.initial_master_width / grid.grid_width
grid.normalize_helper =
	string.format("~/.config/hypr/scripts/hypr-grid-resize %d %d", grid.grid_width, grid.grid_height)

return grid
