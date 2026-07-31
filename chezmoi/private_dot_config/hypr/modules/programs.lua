---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local programs = {
	terminal = "kitty",
	fileManager = "dolphin",
	menu_old = "hyprlauncher",
	menu = [[rofi -show drun -run-command "uwsm app -- {cmd}"]],
	browser = "firefox",
	notes = "obsidian",
	music = "flatpak run com.mastermindzh.tidal-hifi",
	emojis = "rofimoji --selector rofi --action clipboard --clipboarder wl-copy --typer wtype --files emojis",
}

return programs
