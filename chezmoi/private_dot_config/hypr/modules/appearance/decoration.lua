--------------------
---- DECORATION ----
--------------------
local plugin = require("lib.plugin")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		-- Mind the borders!
		gaps_in = 0,
		gaps_out = 5,

		border_size = 0,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},

	decoration = {
		rounding = 0,
		rounding_power = 4,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
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

		glow = {
			enabled = true,
			range = 15,
			render_power = 3,
			color = "#FFC580A4",
			color_inactive = "#000000aa",
		},
	},
})

local myShadow = {
	imgborders = {
		image = "~/.config/hypr/assets/borders/border_squircle.png",
		sizes = { left = 75, right = 75, top = 79, bottom = 79 },
		insets = 60,
		scale = 1,
		smooth = false,
		blur = false,
	},
}

local factorioShadowSquare = {
	imgborders = {
		image = "~/.config/hypr/assets/borders/border_factorio_square.png",
		sizes = 24,
		insets = 8,
		scale = 1,
		smooth = false,
		blur = false,
	},
}

local factorioShadowSquareNoInset = {
	imgborders = {
		image = "~/.config/hypr/assets/borders/border_factorio_no_inset.png",
		sizes = 16,
		insets = 8,
		scale = 1,
		smooth = false,
		blur = false,
	},
}

if plugin.is_loaded("imgborders") then
	hl.config({
		plugin = factorioShadowSquareNoInset,
	})
end
