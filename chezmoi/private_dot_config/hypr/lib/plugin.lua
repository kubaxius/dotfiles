local M = {}

function M.is_loaded(name)
	for _, v in pairs(hl.get_loaded_plugins()) do
		if v.name == name then
			return true
		end
	end
	return false
end

return M
