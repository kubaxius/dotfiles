-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.env("XDG_MENU_PREFIX", "arch-")
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE XDG_MENU_PREFIX GDK_BACKEND QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE"
	)

	-- This ensures that polkit is restarted, because otherwise it may not work properly after a Hyprland restart.
	hl.exec_cmd("systemctl --user reset-failed hyprpolkitagent")
	hl.exec_cmd("systemctl --user restart hyprpolkitagent")

	hl.exec_cmd("dunst")

	hl.exec_cmd("nm-applet")
	hl.exec_cmd("xsettingsd")
	hl.exec_cmd([[test "$DESKTOP_SESSION" = hyprland-uwsm || (waybar & hyprpaper)]])

	hl.exec_cmd("ckb-next -b")

	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("command -v wl-clip-persist >/dev/null 2>&1 && wl-clip-persist --clipboard regular")
	--hl.exec_cmd("firefox")
end)
