-- Temporary workaround for the Hyprland mouse/submap regression.
--
-- Keep the intended mouse binds inside their real submaps. This module only adds
-- disabled top-level fallback binds and enables them while a matching submap is
-- active. When upstream is fixed, deleting this file leaves the normal submap
-- binds in place.

local M = {}
local fallbackBinds = {}

local function copyOptions(options)
	local copied = {}

	for key, value in pairs(options or {}) do
		copied[key] = value
	end

	copied.mouse = true
	return copied
end

function M.update()
	local currentSubmap = hl.get_current_submap()

	for _, bind in ipairs(fallbackBinds) do
		bind.keybind:set_enabled(bind.submap == currentSubmap)
	end
end

function M.bindMouseSubmap(submap, keys, dispatcher, options)
	local keybind = hl.bind(keys, dispatcher, copyOptions(options))
	keybind:set_enabled(false)

	table.insert(fallbackBinds, {
		submap = submap,
		keybind = keybind,
	})

	M.update()
	return keybind
end

hl.on("keybinds.submap", M.update)

return M
