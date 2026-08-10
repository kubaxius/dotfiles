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
	},
})

local myShadow = {
	imgborders = {
		image = "~/.config/hypr/assets/borders/border_squircle.png",
		sizes = "75, 75, 79, 79", -- left, right, top, bottom
		insets = "60, 60, 60, 60",
		--insets = "14, 4, 18, 0", -- left, right, top, bottom
		scale = 1,
		smooth = false,
		-- TODO: Report that blur=false makes the border invisible on
		-- Hyprland 0.56.2; local render-pass fixes were unsuccessful.
		blur = true,
	},
}

local factorioShadowSquare = {
	imgborders = {
		image = "~/.config/hypr/assets/borders/border_factorio_square.png",
		sizes = "24, 24, 24, 24",
		insets = "8, 8, 8, 8",
		scale = 1,
		smooth = false,
		blur = true,
	},
}

local factorioShadowSquareNoInset = {
	imgborders = {
		image = "~/.config/hypr/assets/borders/border_factorio_no_inset.png",
		sizes = "24, 24, 24, 24",
		insets = "8, 8, 8, 8",
		scale = 1,
		smooth = false,
		blur = true,
	},
}

if plugin.is_loaded("imgborders") then
	hl.config({
		plugin = factorioShadowSquareNoInset,
	})
end
