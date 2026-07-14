--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Firefox PIP
-- #TODO get this to follow size set in a variable
hl.window_rule({
	name = "firefox-pip",
	match = { class = "firefox", title = "Picture-in-Picture" },

	size = "400 225",
	move = "monitor_w-20-400 20",
	pin = true,
	float = true,
})

-- Satty - the window that pops up after taking a screenshot
-- #TODO try to get this window on the size and position of the taken screenshot, instead of a fixed one
hl.window_rule({
	name = "satty",
	match = { class = "com.gabm.satty" },

	size = "monitor_w*0.7 monitor_h*0.7",
	center = true,
	float = true,
})

-- class: RimWorldLinux
-- title: RimWorld by Ludeon Studios
-- workspace: 2
-- contentType: none
hl.window_rule({
	name = "rimworld",
	match = { class = "RimWorldLinux" },

	fullscreen = true,
})
