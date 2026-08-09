-----------------------
---- CKB-NEXT PIPE ----
-----------------------

--[[
Thin Hyprland adapter for the reusable ckb-pipe command.

Public API:
  set(color[, options])
    Immediately updates a Pipe animation. options.pipe defaults to 0;
    options.zone limits the update to one ckb-next zone.

  callback(color[, options])
    Returns a zero-argument callback suitable for a Hyprland keybinding or
    event handler.
]]

local M = {}

---Quotes one argument for the shell used by hl.exec_cmd.
---@param value string
---@return string quoted
local function shellQuote(value)
	return "'" .. value:gsub("'", "'\"'\"'") .. "'"
end

---Builds and validates a ckb-pipe invocation.
---@param color string Hex color or configured color name.
---@param options? { pipe?: integer, zone?: string }
---@return string command
local function buildCommand(color, options)
	if type(color) ~= "string" or color == "" then
		error("ckb_pipe color must be a non-empty string")
	end

	options = options or {}
	if type(options) ~= "table" then
		error("ckb_pipe options must be a table")
	end

	local pipe = options.pipe or 0
	if type(pipe) ~= "number" or pipe % 1 ~= 0 or pipe < 0 or pipe > 999 then
		error("ckb_pipe options.pipe must be an integer from 0 to 999")
	end

	local command = "ckb-pipe --pipe " .. tostring(pipe)
	if options.zone ~= nil then
		if type(options.zone) ~= "string" or options.zone == "" then
			error("ckb_pipe options.zone must be a non-empty string")
		end
		command = command .. " --zone " .. shellQuote(options.zone)
	end

	return command .. " -- " .. shellQuote(color)
end

---Immediately updates a ckb-next Pipe animation.
---@param color string Hex color or configured color name.
---@param options? { pipe?: integer, zone?: string }
function M.set(color, options)
	hl.exec_cmd(buildCommand(color, options))
end

---Creates a zero-argument callback that updates a Pipe animation.
---@param color string Hex color or configured color name.
---@param options? { pipe?: integer, zone?: string }
---@return function callback
function M.callback(color, options)
	local command = buildCommand(color, options)
	return function()
		hl.exec_cmd(command)
	end
end

return M
