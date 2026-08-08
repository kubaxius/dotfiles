---------------------------
---- WORKSPACE MAPPING ----
---------------------------

-- HyprExpo lays out Hyprland's numeric workspace IDs in row-major order,
-- starting at the top-left:
--
--     physical IDs          user-facing numbers
--     1  2  3               7  8  9
--     4  5  6               4  5  6
--     7  8  9               1  2  3
--
-- The user-facing side follows a numpad: workspace 1 is the bottom-left tile,
-- even though Hyprland and HyprExpo know that tile as workspace ID 7.
--
-- Treat user input and workspace sections as logical numbers. Convert them to
-- physical IDs only at the Hyprland boundary (binds, rules, and dispatchers).
-- Keeping the translation here gives the rest of the configuration one shared
-- source of truth.
local logical_to_physical = {
	[1] = 7,
	[2] = 8,
	[3] = 9,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 1,
	[8] = 2,
	[9] = 3,
}

local physical_to_logical = {}
for logical, physical in pairs(logical_to_physical) do
	physical_to_logical[physical] = logical
end

local M = {}

---Converts a user-facing workspace number to Hyprland's physical workspace ID.
---Numbers outside the mapped 1-9 grid pass through unchanged; for example,
---logical workspace 10 remains physical workspace 10.
---@param logical integer User-facing workspace number.
---@return integer physical Hyprland workspace ID.
function M.physical(logical)
	return logical_to_physical[logical] or logical
end

---Converts a Hyprland physical workspace ID to its user-facing number.
---Numbers outside the mapped 1-9 grid pass through unchanged; for example,
---physical workspace 10 remains logical workspace 10.
---@param physical integer Hyprland workspace ID.
---@return integer logical User-facing workspace number.
function M.logical(physical)
	return physical_to_logical[physical] or physical
end

---Builds a workspace selector for a rule or dispatcher.
---The optional suffix supports selectors such as `7 silent` while ensuring the
---numeric part is translated through the logical-to-physical map first.
---@param logical integer User-facing workspace number.
---@param suffix? string Selector suffix such as `silent`.
---@return string selector Hyprland workspace selector.
function M.selector(logical, suffix)
	local selector = tostring(M.physical(logical))
	return suffix and (selector .. " " .. suffix) or selector
end

---Builds HyprExpo's comma-separated label map in visible tile order.
---HyprExpo consumes labels by physical position, so this inverts the mapping:
---physical tiles 1-9 receive logical labels `7,8,9,4,5,6,1,2,3`.
---This assumes the overview starts at physical workspace 1 and does not omit
---tiles, as configured by `workspace_method` and `skip_empty`/`max_workspace`.
---@param count integer Number of physical overview tiles to label.
---@return string labels Comma-separated logical labels for HyprExpo.
function M.hyprexpo_labels(count)
	local labels = {}

	for physical = 1, count do
		for logical = 1, count do
			if M.physical(logical) == physical then
				labels[physical] = tostring(logical)
				break
			end
		end
	end

	return table.concat(labels, ",")
end

return M
