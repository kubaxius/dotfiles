-------------------
---- AUTOSTART ----
-------------------

local uwsm = require("lib.uwsm")
local workspaces = require("modules.workspaces")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Most of these should be started by systemd, so prefer creating user scoped unit files and not using this file.
hl.on("hyprland.start", function()
	hl.env("XDG_MENU_PREFIX", "arch-")
	uwsm.start_raw(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE XDG_MENU_PREFIX GDK_BACKEND QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE"
	)
	workspaces.setup_workspaces()
end)
