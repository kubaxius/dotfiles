------------------
---- NOTIFY ----
------------------

local M = {}

function M.send(title, message)
	return hl.dispatch(hl.dsp.exec_cmd(string.format([[notify-send %q %q]], title, message)))
end

function M.hyprland(message)
	return M.send("Hyprland", message)
end

return M
