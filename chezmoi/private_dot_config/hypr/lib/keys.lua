--------------
---- KEYS ----
--------------

local keys = {}

function keys.withMod(mod, key)
	if mod == "" then
		return key
	end

	return mod .. " + " .. key
end

return keys
