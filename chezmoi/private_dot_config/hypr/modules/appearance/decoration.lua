--------------------
---- DECORATION ----
--------------------
local plugin = require("lib.plugin")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,

		border_size = 0,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},

	decoration = {
		rounding = 0,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1a1a)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
})

if plugin.is_loaded("imgborders") then
	hl.config({
		plugin = {
			imgborders = {
				image = "~/.config/hypr/assets/test_frame2.png",
				sizes = "40, 40, 40, 40", -- top, right, bottom, left
				insets = "20, 20, 20, 20", -- top, right, bottom, left
				scale = 1,
				smooth = false,
				blur = true, -- broken for now, has to be true
			},
		},
	})
end
