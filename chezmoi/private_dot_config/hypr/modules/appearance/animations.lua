--------------------
---- ANIMATIONS ----
--------------------

hl.config({
	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- `speed` is a duration measured in deciseconds (1 = 100 ms), not a
-- multiplier. Lower values finish faster; for example, 1.5 is about 150 ms.
-- Unconfigured leaves inherit the nearest configured parent in this tree.

-- Fallback for every animation that does not have a more specific setting.
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })

-----------------
---- WINDOWS ----
-----------------

-- Parent for opening, closing, moving, dragging, and resizing windows.
-- More-specific windowsIn/windowsOut/windowsMove settings override it below.
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
-- Window movement, dragging, and resizing; Hyprexpo also uses this leaf for
-- both its opening and closing zoom animations.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, bezier = "easeOutQuint" })
-- Windows appearing, including the configured pop-in scale.
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
-- Windows disappearing, including the configured pop-out scale.
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })

------------------
---- OPACITY -----
------------------

-- Parent for opacity transitions that do not have a more-specific fade leaf.
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
-- Window opacity while a window appears.
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
-- Window opacity while a window disappears.
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })

-- Missing fade leaves currently inherit `fade`; uncomment to tune separately.
-- Active/inactive opacity changes when focus switches between windows.
-- hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3.03, bezier = "quick" })
-- Window shadow opacity changes.
-- hl.animation({ leaf = "fadeShadow", enabled = true, speed = 3.03, bezier = "quick" })
-- Window glow opacity changes.
-- hl.animation({ leaf = "fadeGlow", enabled = true, speed = 3.03, bezier = "quick" })
-- Dimming changes, such as inactive-window or modal dimming.
-- hl.animation({ leaf = "fadeDim", enabled = true, speed = 3.03, bezier = "quick" })
-- Parent for fading layer surfaces; fadeLayersIn/fadeLayersOut override it.
-- hl.animation({ leaf = "fadeLayers", enabled = true, speed = 3.03, bezier = "quick" })
-- Opacity of layer surfaces while they appear.
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
-- Opacity of layer surfaces while they disappear.
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
-- Parent for Wayland popup fades.
-- hl.animation({ leaf = "fadePopups", enabled = true, speed = 3.03, bezier = "quick" })
-- Wayland popup opacity while a popup appears.
-- hl.animation({ leaf = "fadePopupsIn", enabled = true, speed = 3.03, bezier = "quick" })
-- Wayland popup opacity while a popup disappears.
-- hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 3.03, bezier = "quick" })
-- Screen fade when display power management turns monitors on or off.
-- hl.animation({ leaf = "fadeDpms", enabled = true, speed = 3.03, bezier = "quick" })

----------------
---- LAYERS ----
----------------

-- Parent for positional animations of layer surfaces such as launchers,
-- notifications, panels, and wallpapers.
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
-- Layer surfaces appearing; their separate opacity uses fadeLayersIn.
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
-- Layer surfaces disappearing; their separate opacity uses fadeLayersOut.
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })

-------------------
---- WORKSPACES ----
-------------------

-- Parent for ordinary workspace transitions.
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- Transition into the newly selected workspace.
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
-- Transition out of the previously selected workspace.
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- Missing special-workspace leaves inherit `workspaces`; uncomment to tune.
-- Parent for showing and hiding scratchpad/special workspaces.
-- hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- Transition while a scratchpad/special workspace appears.
-- hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- Transition while a scratchpad/special workspace disappears.
-- hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

---------------------
---- DECORATIONS ----
---------------------

-- Active/inactive window border color transitions.
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

-- Missing decoration leaves inherit `global`; uncomment to tune separately.
-- Rotation of animated border gradients. A looping style renders continuously.
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 10, bezier = "default", style = "once" })
-- Rotation of animated shadow gradients.
-- hl.animation({ leaf = "shadowangle", enabled = true, speed = 10, bezier = "default", style = "once" })
-- Rotation of animated glow gradients.
-- hl.animation({ leaf = "glowangle", enabled = true, speed = 10, bezier = "default", style = "once" })

----------------
---- DISPLAY ----
----------------

-- Accessibility screen-zoom interpolation.
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
-- Zoom animation when a monitor is added.
-- hl.animation({ leaf = "monitorAdded", enabled = true, speed = 10, bezier = "default" })
