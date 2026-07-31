--------------
---- UWSM ----
--------------

-- Hyprland-launched applications should run as UWSM/systemd units.
-- Keep all app/session launch policy here so future binds and autostarts
-- make the UWSM choice by default.

local M = {}

---Builds the optional UWSM scope-unit argument for an application launch.
---Validates the suffix to prevent unsafe shell arguments in generated commands.
---@param unit_name? string Scope unit suffix, without the `hyprland-` prefix.
---@return string option The formatted option, or an empty string when no unit is requested.
local function unit_option(unit_name)
	if not unit_name or unit_name == "" then
		return ""
	end

	if unit_name:find("[^%w_.@:-]") then
		error("Invalid UWSM unit name suffix: " .. unit_name)
	end

	return " -u hyprland-" .. unit_name .. ".scope"
end

---Creates a shell command that launches an application in a UWSM scope. DOES NOT EXECUTE IT.
---Uses `uwsm-app` when available and falls back to the legacy `uwsm app` command for compatibility.
---@param command string Shell command for the application to launch.
---@param unit_name? string Scope unit suffix used to name the systemd scope.
---@return string command Shell command that runs the application through UWSM.
function M.app(command, unit_name)
	local unit = unit_option(unit_name)

	return "if command -v uwsm-app >/dev/null 2>&1; then exec uwsm-app -t scope"
		.. unit
		.. " -- "
		.. command
		.. "; else exec uwsm app -t scope"
		.. unit
		.. " -- "
		.. command
		.. "; fi"
end

---Creates and retrurns a Hyprland `exec` directive that starts an application through UWSM.
---@param command string Shell command for the application to launch.
---@param unit_name? string Scope unit suffix used to name the systemd scope.
---@return string directive Hyprland configuration directive.
function M.exec(command, unit_name)
	return hl.dsp.exec_cmd(M.app(command, unit_name))
end

---Immediately starts an application through UWSM from Lua configuration code.
---@param command string Shell command for the application to launch.
---@param unit_name? string Scope unit suffix used to name the systemd scope.
function M.start(command, unit_name)
	hl.exec_cmd(M.app(command, unit_name))
end

---Starts an application in a UWSM scope with Hyprland one-shot window rules.
---Scope mode preserves the launch process chain Hyprland uses to associate the first window with these rules.
---@param command string Shell command for the application to launch.
---@param unit_name? string Scope unit suffix used to name the systemd scope.
---@param rules table Hyprland window rules applied to the first created window.
function M.start_with_rules(command, unit_name, rules)
	hl.exec_cmd(M.app(command, unit_name), rules)
end

---Creates a Hyprland `exec` directive without routing the command through UWSM.
---Use this for commands that must run outside a UWSM-managed application scope.
---@param command string Shell command to include in the directive.
---@return string directive Hyprland configuration directive.
function M.raw(command)
	return hl.dsp.exec_cmd(command)
end

---Immediately runs a shell command without routing it through UWSM.
---Use this for commands that must run outside a UWSM-managed application scope.
---@param command string Shell command to run.
function M.start_raw(command)
	hl.exec_cmd(command)
end

---Creates a Hyprland `exec` directive that stops the active UWSM session.
---@return string directive Hyprland configuration directive.
function M.stop()
	return hl.dsp.exec_cmd("uwsm stop")
end

return M
