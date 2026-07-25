--------------
---- UWSM ----
--------------

-- Hyprland-launched applications should run as UWSM/systemd units.
-- Keep all app/session launch policy here so future binds and autostarts
-- make the UWSM choice by default.

local uwsm = {}

local function unit_option(unit_name)
	if not unit_name or unit_name == "" then
		return ""
	end

	if unit_name:find("[^%w_.@:-]") then
		error("Invalid UWSM unit name suffix: " .. unit_name)
	end

	return " -u hyprland-" .. unit_name .. ".scope"
end

function uwsm.app(command, unit_name)
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

function uwsm.exec(command, unit_name)
	return hl.dsp.exec_cmd(uwsm.app(command, unit_name))
end

function uwsm.start(command, unit_name)
	hl.exec_cmd(uwsm.app(command, unit_name))
end

function uwsm.raw(command)
	return hl.dsp.exec_cmd(command)
end

function uwsm.start_raw(command)
	hl.exec_cmd(command)
end

function uwsm.stop()
	return hl.dsp.exec_cmd("uwsm stop")
end

return uwsm
