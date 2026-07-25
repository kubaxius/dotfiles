----------------
---- SUBMAPS ----
----------------

local M = {}

function M.define(name, blocks, resetTo, callback, useBindBlocks)
	if type(blocks) == "function" then
		callback = blocks
		blocks = {}
	elseif type(blocks) == "string" and type(resetTo) == "function" then
		callback = resetTo
		resetTo = blocks
		blocks = {}
	elseif type(resetTo) == "function" and callback == nil then
		callback = resetTo
		resetTo = nil
	end

	blocks = blocks or {}
	callback = callback or function() end

	local function defineBinds()
		useBindBlocks(blocks)
		callback()
	end

	if resetTo then
		return hl.define_submap(name, resetTo, defineBinds)
	end

	return hl.define_submap(name, defineBinds)
end

return M
