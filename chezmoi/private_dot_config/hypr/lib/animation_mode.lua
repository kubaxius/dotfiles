------------------------
---- ANIMATION MODE ----
------------------------

--[[
Animation Mode owns the persistent, session-wide choice between Hyprland's
"fancy" and "fast" profiles.

The selected mode is stored in $XDG_STATE_HOME/hyprland/animation-mode (or the
equivalent path below ~/.local/state). Loading this module restores that value
and applies its profile immediately, which also makes config reloads preserve
the selected behavior.

Public API:
  get_mode()
    Returns the active profile name: "fancy" or "fast".

  set_mode(mode)
    Validates, applies, and persists the requested profile.

  toggle_mode()
    Switches profiles and displays a Hyprland notification.
]]

local notify = require("lib.notify")

local M = {}

local defaultMode = "fancy"
local profiles = {
	fancy = {
		animations = true,
	},
	fast = {
		animations = false,
	},
}

local stateHome = os.getenv("XDG_STATE_HOME") or ((os.getenv("HOME") or "") .. "/.local/state")
local stateDirectory = stateHome .. "/hyprland"
local stateFile = stateDirectory .. "/animation-mode"
local currentMode

-- TODO: Revisit external filesystem helpers when more persistent state is
-- added. LuaFileSystem would replace shell-based directory operations, while
-- Penlight adds recursive path creation and higher-level file helpers on top
-- of LuaFileSystem. If adopted, install the Lua 5.4 modules through Ansible and
-- verify that Hyprland's embedded Lua can resolve their package paths.

---Checks whether a profile name is supported.
---@param mode string
---@return boolean valid
local function isValidMode(mode)
	return profiles[mode] ~= nil
end

---Reads a valid persisted mode, falling back safely when none is available.
---@return "fancy"|"fast" mode
local function readPersistedMode()
	local file = io.open(stateFile, "r")
	if file then
		local mode = file:read("*l")
		file:close()

		if isValidMode(mode) then
			return mode
		end
	end

	return defaultMode
end

---Persists a mode atomically so readers never observe a partial value.
---@param mode "fancy"|"fast"
---@return boolean persisted
local function persistMode(mode)
	local mkdirOk = os.execute(string.format("mkdir -p %q", stateDirectory))
	if mkdirOk ~= true and mkdirOk ~= 0 then
		print("Could not create animation mode state directory: " .. stateDirectory)
		return false
	end

	local temporaryFile = stateFile .. ".tmp"
	local file = io.open(temporaryFile, "w")
	if not file then
		print("Could not write animation mode state: " .. temporaryFile)
		return false
	end

	file:write(mode, "\n")
	file:close()

	local renamed, err = os.rename(temporaryFile, stateFile)
	if not renamed then
		print("Could not persist animation mode: " .. tostring(err))
		return false
	end

	return true
end

---Applies every Hyprland setting belonging to a profile.
---@param mode "fancy"|"fast"
local function applyProfile(mode)
	local profile = profiles[mode]
	hl.config({
		animations = {
			enabled = profile.animations,
		},
	})
end

---Returns the active animation profile.
---@return "fancy"|"fast" mode
function M.get_mode()
	return currentMode
end

---Applies and persists an animation profile.
---@param mode "fancy"|"fast"
---@return "fancy"|"fast" mode
function M.set_mode(mode)
	if not isValidMode(mode) then
		error("Unknown animation mode: " .. tostring(mode))
	end

	currentMode = mode
	applyProfile(mode)
	persistMode(mode)

	return currentMode
end

---Toggles the active profile and reports the new value.
---@return "fancy"|"fast" mode
function M.toggle_mode()
	local mode = currentMode == "fancy" and "fast" or "fancy"
	M.set_mode(mode)
	notify.hyprland("Animation mode: " .. mode)

	return mode
end

-- Restore the persisted profile after the base animation config has loaded.
currentMode = readPersistedMode()
applyProfile(currentMode)

return M
