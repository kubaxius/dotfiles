--------------
---- KEYS ----
--------------

local M = {}

function M.with_mod(mod, key)
	if mod == "" then
		return key
	end

	return mod .. " + " .. key
end

return M
