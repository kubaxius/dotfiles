-----------------------
---- BIND BLOCKS ----
-----------------------

--[[
Bind Blocks provide a small keybinding composition layer on top of Hyprland's
native bind API.

A bind block is a named collection of related keybindings, such as window
management commands, launcher shortcuts, media keys, or mode-specific controls.
Instead of scattering those bindings directly through the configuration, callers
define the group once and then opt into it by name. This keeps shared bindings
consistent across the default keymap and any Hyprland submaps that reuse them.

Ordinary bind blocks are reusable templates. Calling useBindBlock(name) or
useBindBlocks({ ... }) executes the block callback and creates its binds in the
current Hyprland binding context. This is useful for repeated sets of static
bindings, including submaps.

Toggleable bind blocks are dynamic runtime groups. When defineBindBlock receives
a toggle specification, the block is materialized once, every bind handle created
through bindBlocks.bind(...) is captured, and those handles are disabled by
default unless toggleSpec.enabled is true. The configured toggle bind remains
outside the captured group so the user can always switch the block on or off.

Use toggleable blocks for temporary modes that should not be Hyprland submaps.
For example, a numpad workspace mode can temporarily claim KP_1..KP_9 while
leaving the rest of the global keymap and any true submaps alone.

Public API:
  bind(bind, dispatcher, options)
    Wrapper around hl.bind. Use this inside bind block callbacks so toggleable
    blocks can record their Hyprland handles.

  defineBindBlock(name, callback[, toggleSpec])
    Registers a named block. With no toggleSpec, the block is an ordinary
    reusable template. With a toggleSpec, the block becomes a managed runtime
    group.

  useBindBlock(name), useBindBlocks(blocks)
    Installs ordinary blocks into the current binding context. Toggleable blocks
    are ignored here because they are installed once at definition time.

  enableBlock(name), disableBlock(name), toggleBlock(name), isBlockEnabled(name)
    Runtime controls for toggleable blocks.

Toggle spec:
  "code:77"
    String shorthand for a toggle bind.

  {
    bind = "code:77",
    enabled = false,
    options = { submap_universal = true },
    on_enable = function() end,
    on_disable = function() end,
  }
    Full form. options defaults to { submap_universal = true } so mode toggles
    remain reachable from Hyprland submaps.
]]

local bindBlocks = {}
local activeCapture = nil

-- Lua modules commonly return a table named M. The name is conventional only:
-- it marks the public module API exported at the bottom of this file.
local M = {}

local function blockCommand(action, name)
	return hl.dsp.exec_cmd(string.format([[hyprctl dispatch 'require("lib.bind-blocks").%s(%q)']], action, name))
end

local function normalizeToggleSpec(toggleSpec)
	if type(toggleSpec) == "string" then
		return { bind = toggleSpec }
	end

	if type(toggleSpec) ~= "table" then
		error("Toggle spec must be a string or table")
	end

	if not toggleSpec.bind then
		error("Toggle spec requires a bind")
	end

	return toggleSpec
end

local function setHandlesEnabled(block, enabled)
	for _, handle in ipairs(block.handles or {}) do
		handle:set_enabled(enabled)
	end

	block.enabled = enabled
end

local function setBlockEnabled(name, enabled, notify)
	local block = bindBlocks[name]

	if not block then
		error("Unknown bind block: " .. name)
	end

	if not block.toggle then
		error("Bind block is not toggleable: " .. name)
	end

	if block.enabled == enabled then
		return
	end

	setHandlesEnabled(block, enabled)

	if notify then
		local callback = enabled and block.toggle.on_enable or block.toggle.on_disable

		if callback then
			callback()
		end
	end
end

function M.bind(bind, dispatcher, options)
	local handle = hl.bind(bind, dispatcher, options)

	if activeCapture then
		table.insert(activeCapture.handles, handle)
	end

	return handle
end

function M.defineBindBlock(name, callback, toggleSpec)
	if bindBlocks[name] then
		error("Bind block already defined: " .. name)
	end

	local block = {
		callback = callback,
		handles = {},
	}

	bindBlocks[name] = block

	if not toggleSpec then
		return
	end

	local toggle = normalizeToggleSpec(toggleSpec)
	block.toggle = toggle

	local previousCapture = activeCapture
	activeCapture = block
	local ok, err = pcall(callback)
	activeCapture = previousCapture

	if not ok then
		error(err)
	end

	setHandlesEnabled(block, toggle.enabled == true)
	M.bind(toggle.bind, blockCommand("toggleBlock", name), toggle.options or { submap_universal = true })
end

function M.enableBlockDispatcher(name)
	return blockCommand("enableBlock", name)
end

function M.disableBlockDispatcher(name)
	return blockCommand("disableBlock", name)
end

function M.toggleBlockDispatcher(name)
	return blockCommand("toggleBlock", name)
end

function M.useBindBlock(name)
	local block = bindBlocks[name]

	if not block then
		error("Unknown bind block: " .. name)
	end

	if block.toggle then
		return
	end

	block.callback()
end

function M.useBindBlocks(blocks)
	for _, block in ipairs(blocks or {}) do
		if type(block) == "function" then
			block()
		else
			M.useBindBlock(block)
		end
	end
end

function M.enableBlock(name)
	setBlockEnabled(name, true, true)
end

function M.disableBlock(name)
	setBlockEnabled(name, false, true)
end

function M.toggleBlock(name)
	local block = bindBlocks[name]

	if not block then
		error("Unknown bind block: " .. name)
	end

	setBlockEnabled(name, not block.enabled, true)
end

function M.isBlockEnabled(name)
	local block = bindBlocks[name]

	if not block then
		error("Unknown bind block: " .. name)
	end

	return block.enabled == true
end

return M
