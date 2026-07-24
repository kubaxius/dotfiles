--------------
---- UWSM ----
--------------

-- Hyprland-launched applications should run as UWSM/systemd units.
-- Keep all app/session launch policy here so future binds and autostarts
-- make the UWSM choice by default.

local uwsm = {}

function uwsm.app(command)
	return "if command -v uwsm-app >/dev/null 2>&1; then uwsm-app -- "
		.. command
		.. "; else uwsm app -- "
		.. command
		.. "; fi"
end

function uwsm.exec(command)
	return hl.dsp.exec_cmd(uwsm.app(command))
end

function uwsm.start(command)
	hl.exec_cmd(uwsm.app(command))
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
