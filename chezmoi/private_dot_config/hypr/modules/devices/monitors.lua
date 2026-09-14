------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "0x0",
	scale = 1.5,
})

hl.monitor({
	output = "HEADLESS-1",
	mode = "1280x800@60",
	position = "0x1440",
	scale = 1,
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
