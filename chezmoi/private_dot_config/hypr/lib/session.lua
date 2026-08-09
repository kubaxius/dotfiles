-----------------
---- SESSION ----
-----------------

--[[
Session provides shared persistent state for the Hyprland configuration.

The completed module will keep one in-memory Lua table and serialize it to a
single JSON file below XDG_STATE_HOME. Callers should interact with that state
only through this public API instead of reading or writing the file directly.

It should restore state autmatically at the startup, so we need to somehow find a way to do this,
without the need of each state to query it on it's own.

Public API:
  remember(name, value)
    Stores a JSON-compatible value and persists the session.

  restore(name, defaultValue)
    Returns a stored value, or defaultValue when the name is not present.

  forget(name)
    Removes a stored value and persists the session.

  reload()
    Replaces the in-memory state with the contents of the session file.
]]

local json = require("dkjson")
local directory = require("pl.dir")
local file = require("pl.file")
local path = require("pl.path")

local M = {}

local stateHome = os.getenv("XDG_STATE_HOME") or ((os.getenv("HOME") or "~") .. "/.local/state")
local sessionDir = stateHome .. "/hyprland"
local sessionFile = sessionDir .. "/session.json"

local function ensurePath()
	if not path.exists(sessionFile) then
		directory.makepath(sessionDir)
		return file.write(sessionFile, "{}")
	end
	return true
end

local function readSession()
	ensurePath()
	local sessionString = file.read(sessionFile)
	local session = json.decode(sessionString)
	return session
end

local function saveSession(session)
	ensurePath()
	local sessionString = json.encode(session)
	print(sessionString, type(sessionString))
	return file.write(sessionFile, sessionString)
end

---Stores and persists a named session value.
---@param name string
---@param value unknown
---@return boolean? remembered
---@return string? error
function M.remember(name, value)
	local session = readSession()
	session[name] = value
	return saveSession(session)
end

---Restores a named session value.
---@generic T
---@param name string
---@param defaultValue? T
--- --@return unknown|T value
function M.restore(name, defaultValue)
	-- TODO: Implement lookup with a default value.
end

---Removes and persists a named session value.
---@param name string
---@return boolean? forgotten
---@return string? error
function M.forget(name)
	M.remember(name, nil)
end

return M
