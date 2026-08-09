----------------------------
---- WORKSPACE SWITCHER ----
----------------------------

--[[
Workspace Switcher builds keybinding callbacks that choose their behavior from
the active animation profile.

Fast mode dispatches an ordinary workspace focus immediately. Fancy mode first
opens the configured 3x3 Hyprexpo grid and selects the resolved workspace after
a short one-shot timer. Starting another switch cancels the previous timer so
rapid input always lands on the most recently requested workspace.

Relative existing-workspace selectors (e.g. "e+1" and "e-1") are resolved
explicitly in the user-facing order defined by lib.workspace_map. Hyprland's
direct workspace lookup uses physical IDs and does not consistently resolve
those selectors when called from Lua callbacks used by wheel bindings.

Public API:
  switch_workspace(target[, forceFast])
    Returns a mode-aware callback for a logical workspace number or selector.
    When forceFast is true, the callback always focuses the workspace directly.

  move_window_to_workspace(target[, follow])
    Returns a dispatcher that moves a window to a logical workspace number.

  select_hyprexpo_workspace(target)
    Returns a callback that selects a logical workspace in an open Hyprexpo.
]]

local animationMode = require("lib.animation_mode")
local notify = require("lib.notify")
local workspaceMap = require("lib.workspace_map")

local M = {}

-- Debounce long enough for a rapid follow-up key to replace the first request.
-- Hyprexpo's visual speed is controlled separately by the windowsMove animation.
local selectionDelayMs = 2
local pendingSelection

---Translates a public logical target to Hyprland's physical workspace ID.
---String selectors pass through for resolution at keypress time.
---@param target integer|string Logical workspace number or selector.
---@return integer|string target Hyprland workspace ID or selector.
local function physicalTarget(target)
	if type(target) == "number" then
		return workspaceMap.physical(target)
	end

	return target
end

---Cancels any delayed Hyprexpo selection.
local function cancelPendingSelection()
	if pendingSelection then
		pendingSelection:set_enabled(false)
		pendingSelection = nil
	end
end

---Immediately focuses a Hyprland workspace ID or selector.
---@param target integer|string
local function focusWorkspace(target)
	hl.dispatch(hl.dsp.focus({ workspace = target }))
end

---Handles a request to switch to the workspace that is already active.
---Keep this behavior isolated so it can grow without complicating switching.
---@param workspaceId integer Hyprland physical workspace ID.
local function onSameWorkspace(workspaceId)
	notify.hyprland("Already on workspace " .. workspaceMap.logical(workspaceId))
end

---Returns existing numeric workspace IDs in user-facing logical order.
---@return integer[] workspaceIds
local function existingWorkspaceIdsInLogicalOrder()
	local workspaceIds = {}

	for _, workspace in ipairs(hl.get_workspaces() or {}) do
		if workspace.id and workspace.id > 0 then
			table.insert(workspaceIds, workspace.id)
		end
	end

	table.sort(workspaceIds, function(left, right)
		return workspaceMap.logical(left) < workspaceMap.logical(right)
	end)
	return workspaceIds
end

---Resolves an e+N/e-N selector relative to the active existing workspace.
---@param target string
---@return integer? workspaceId
local function resolveExistingRelativeSelector(target)
	local sign, distanceText = target:match("^e([+-])(%d+)$")
	if not sign then
		return nil
	end

	local activeWorkspace = hl.get_active_workspace()
	if not activeWorkspace or not activeWorkspace.id then
		return nil
	end

	local workspaceIds = existingWorkspaceIdsInLogicalOrder()
	if #workspaceIds == 0 then
		return nil
	end

	local activeIndex
	for index, workspaceId in ipairs(workspaceIds) do
		if workspaceId == activeWorkspace.id then
			activeIndex = index
			break
		end
	end

	if not activeIndex then
		return nil
	end

	local distance = tonumber(distanceText)
	local offset = sign == "+" and distance or -distance
	local targetIndex = ((activeIndex - 1 + offset) % #workspaceIds) + 1
	return workspaceIds[targetIndex]
end

---Resolves a workspace ID or selector to the concrete ID Hyprexpo expects.
---@param target integer|string
---@return integer? workspaceId
local function resolveWorkspaceId(target)
	-- Narrow on the string branch explicitly. LuaLS does not infer that an
	-- integer|string union becomes string after checking for runtime "number".
	if type(target) ~= "string" then
		return target
	end

	local relativeWorkspaceId = resolveExistingRelativeSelector(target)
	if relativeWorkspaceId then
		return relativeWorkspaceId
	end

	local workspace = hl.get_workspace(target)
	return workspace and workspace.id or nil
end

---Builds a mode-aware workspace switch callback for use in a keybinding.
---@param target integer|string Logical workspace number or Hyprland selector.
---@param forceFast? boolean Always focus directly, regardless of animation mode.
---@return function callback
function M.switch_workspace(target, forceFast)
	local physicalWorkspaceTarget = physicalTarget(target)

	return function()
		local resolvedTarget = resolveWorkspaceId(physicalWorkspaceTarget) or physicalWorkspaceTarget
		local activeWorkspace = hl.get_active_workspace()

		if type(resolvedTarget) == "number" and activeWorkspace and activeWorkspace.id == resolvedTarget then
			cancelPendingSelection()
			onSameWorkspace(resolvedTarget)
			return
		end

		if forceFast or animationMode.get_mode() == "fast" then
			cancelPendingSelection()
			focusWorkspace(resolvedTarget)
			return
		end

		local workspaceId = resolvedTarget
		-- Hyprexpo is configured as a 3x3 grid. Keep workspace 10 and targets
		-- outside that grid usable by falling back to direct workspace focus.
		if type(workspaceId) ~= "number" or workspaceId < 1 or workspaceId > 9 then
			cancelPendingSelection()
			focusWorkspace(resolvedTarget)
			return
		end

		cancelPendingSelection()
		hl.plugin.hyprexpo.expo("on")

		local timer
		timer = hl.timer(function()
			-- A newer request may have disabled and replaced this timer. Checking
			-- identity keeps a stale callback from selecting its old workspace.
			if pendingSelection ~= timer then
				return
			end

			pendingSelection = nil
			hl.plugin.hyprexpo.kb_selecti(workspaceId)
		end, { timeout = selectionDelayMs, type = "oneshot" })
		pendingSelection = timer
	end
end

---Builds a dispatcher that moves the active window to a logical workspace.
---@param target integer|string Logical workspace number or Hyprland selector.
---@param follow? boolean Whether to follow the moved window.
---@return any dispatcher
function M.move_window_to_workspace(target, follow)
	return hl.dsp.window.move({ workspace = physicalTarget(target), follow = follow })
end

---Builds a callback that selects a logical workspace in an open Hyprexpo view.
---@param target integer Logical workspace number.
---@return function callback
function M.select_hyprexpo_workspace(target)
	local workspaceId = workspaceMap.physical(target)

	return function()
		-- The first key may still have a delayed selection pending from opening
		-- Hyprexpo. A later submap key must supersede that original request.
		cancelPendingSelection()
		hl.plugin.hyprexpo.kb_selecti(workspaceId)
	end
end

return M
