-------------------
---- AUTOSTART ----
-------------------

local uwsm = require("lib.uwsm")
local workspaces = require("modules.window-management.workspaces")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Most of these should be started by systemd, so prefer creating user scoped unit files and not using this file.
hl.on("hyprland.start", function()
	hl.env("XDG_MENU_PREFIX", "arch-")
	-- Ensure plugins are loaded
	uwsm.start_raw("hyprpm reload")
	uwsm.start_raw(
		"dbus-update-activation-environment --systemd "
			.. "WAYLAND_DISPLAY DISPLAY "
			.. "XDG_CURRENT_DESKTOP "
			.. "XDG_SESSION_DESKTOP "
			.. "XDG_SESSION_TYPE "
			.. "XDG_MENU_PREFIX "
			.. "GDK_BACKEND "
			.. "QT_QPA_PLATFORM "
			.. "QT_QPA_PLATFORMTHEME "
			.. "QT_STYLE_OVERRIDE"
	)

	-- Create the virtual tablet output once per Hyprland session.
	uwsm.start_raw(
		"dbus-update-activation-environment --systemd "
			.. "WAYLAND_DISPLAY "
			.. "DISPLAY "
			.. "HYPRLAND_INSTANCE_SIGNATURE "
			.. "XDG_CURRENT_DESKTOP "
			.. "XDG_SESSION_DESKTOP "
			.. "XDG_SESSION_TYPE "
			.. "&& ~/.config/hypr/scripts/ensure-tablet-output "
			.. "&& sleep 2 "
			.. "&& systemctl --user restart app-dev.lizardbyte.app.Sunshine.service"
	)

	workspaces.setup_workspaces()
end)
