---------------------
---- LAYOUT GRID ----
---------------------

local M = {}

local function positiveInteger(name, value)
	if type(value) ~= "number" or value < 1 or value % 1 ~= 0 then
		error(name .. " must be a positive integer")
	end
end

---Builds the shared values used to configure and normalize a tiled layout.
---@param settings { grid_width: integer, grid_height: integer, initial_master_width: integer }
---@return table grid
function M.create(settings)
	positiveInteger("grid_width", settings.grid_width)
	positiveInteger("grid_height", settings.grid_height)
	positiveInteger("initial_master_width", settings.initial_master_width)

	if settings.initial_master_width >= settings.grid_width then
		error("initial_master_width must be smaller than grid_width")
	end

	return {
		grid_width = settings.grid_width,
		grid_height = settings.grid_height,
		initial_master_width = settings.initial_master_width,
		initial_master_factor = settings.initial_master_width / settings.grid_width,
		normalize_helper = string.format(
			"~/.config/hypr/scripts/hypr-grid-resize %d %d",
			settings.grid_width,
			settings.grid_height
		),
	}
end

return M
