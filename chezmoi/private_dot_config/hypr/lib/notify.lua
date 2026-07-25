------------------
---- NOTIFY ----
------------------

local notify = {}

function notify.send(title, message)
	return hl.dispatch(hl.dsp.exec_cmd(string.format([[notify-send %q %q]], title, message)))
end

function notify.hyprland(message)
	return notify.send("Hyprland", message)
end

return notify
