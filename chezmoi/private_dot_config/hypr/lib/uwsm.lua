--------------
---- UWSM ----
--------------

-- Hyprland-launched applications should run as UWSM/systemd units.
-- Keep all app/session launch policy here so future binds and autostarts
-- make the UWSM choice by default.

local M = {}

local function unit_option(unit_name)
	if not unit_name or unit_name == "" then
		return ""
	end

	if unit_name:find("[^%w_.@:-]") then
		error("Invalid UWSM unit name suffix: " .. unit_name)
	end

	return " -u hyprland-" .. unit_name .. ".scope"
end

function M.app(command, unit_name)
	local unit = unit_option(unit_name)

	return "if command -v uwsm-app >/dev/null 2>&1; then uwsm-app"
		.. unit
		.. " -- "
		.. command
		.. "; else uwsm app"
		.. unit
		.. " -- "
		.. command
		.. "; fi"
end

function M.exec(command, unit_name)
	return hl.dsp.exec_cmd(M.app(command, unit_name))
end

function M.start(command, unit_name)
	hl.exec_cmd(M.app(command, unit_name))
end

function M.raw(command)
	return hl.dsp.exec_cmd(command)
end

function M.start_raw(command)
	hl.exec_cmd(command)
end

function M.stop()
	return hl.dsp.exec_cmd("uwsm stop")
end

return M
