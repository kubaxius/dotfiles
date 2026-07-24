---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_file = "~/.config/hypr/xkb/pl-no-numlock.xkb",

		follow_mouse = 1,

		touchpad = {
			natural_scroll = false,
		},
	},
})

local function mouse_device(name)
	hl.device({
		name = name,
		sensitivity = 0.0,
		accel_profile = "flat",
		tags = "naga, main-mouse",
	})
end

local function mouse_buttons_device(name)
	hl.device({
		name = name,
		tags = "naga, main-mouse",
	})
end

-- Naga can be connected by BT, cable or dongle, so we need to add all possible names to the config.
mouse_device("razer-razer-naga-v2-pro")
mouse_device("razer-razer-naga-v2-pro-2")
mouse_device("razer-razer-naga-v2-pro-4")
mouse_device("razer-razer-naga-v2-pro-6")
mouse_device("razer-razer-naga-v2-pro-7")

mouse_buttons_device("razer-razer-naga-v2-pro-1")
mouse_buttons_device("razer-razer-naga-v2-pro-3")
mouse_buttons_device("razer-razer-naga-v2-pro-5")

hl.device({
	name = "ckb1:-corsair-k100-rgb-optical-mechanical-gaming-keyboard-vkb",
	tags = "ckb100, main-keyboard",
})
