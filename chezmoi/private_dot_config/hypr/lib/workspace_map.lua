-- Keep user-facing workspace numbers in numpad order while Hyprland stores
-- workspaces from top-left to bottom-right.
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

local M = {}

function M.physical(logical)
	return logical_to_physical[logical] or logical
end

function M.selector(logical, suffix)
	local selector = tostring(M.physical(logical))
	return suffix and (selector .. " " .. suffix) or selector
end

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
