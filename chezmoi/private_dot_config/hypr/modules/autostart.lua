-------------------
---- AUTOSTART ----
-------------------

local uwsm = require("lib.uwsm")
local workspaces = require("modules.workspaces")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.env("XDG_MENU_PREFIX", "arch-")
	uwsm.start_raw(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE XDG_MENU_PREFIX GDK_BACKEND QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE"
	)

	-- This ensures that polkit is restarted, because otherwise it may not work properly after a Hyprland restart.
	uwsm.start_raw("systemctl --user reset-failed hyprpolkitagent")
	uwsm.start_raw("systemctl --user restart hyprpolkitagent")

	uwsm.start("dunst", "dunst")

	uwsm.start("nm-applet", "nm-applet")
	uwsm.start("xsettingsd", "xsettingsd")
	uwsm.start_raw([[test "$DESKTOP_SESSION" = hyprland-uwsm || (waybar & hyprpaper)]])

	uwsm.start("ckb-next -b", "ckb-next")

	uwsm.start("wl-paste --type text --watch cliphist store", "wl-paste-text")
	uwsm.start("wl-paste --type image --watch cliphist store", "wl-paste-image")
	uwsm.start(
		[[sh -lc 'command -v wl-clip-persist >/dev/null 2>&1 && exec wl-clip-persist --clipboard regular']],
		"wl-clip-persist"
	)
	workspaces.setup_workspaces()
end)
