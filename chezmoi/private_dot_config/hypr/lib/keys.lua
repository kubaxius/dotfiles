--------------
---- KEYS ----
--------------

local M = {}

function M.withMod(mod, key)
	if mod == "" then
		return key
	end

	return mod .. " + " .. key
end

return M
