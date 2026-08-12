---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local programs = {
	scripts_dir = "~/.config/hypr/scripts/",
	terminal = "kitty",
	fileManager = "dolphin",
	menu_default = "hyprlauncher",
	menu_rofi = [[rofi -show drun -run-command "uwsm app -- {cmd}"]],
	menu = "ncat -U /run/user/1000/walker/walker.sock",
	browser = "firefox",
	notes = "obsidian",
	music = "flatpak run com.mastermindzh.tidal-hifi",
	emojis = "rofimoji --selector rofi --action clipboard --clipboarder wl-copy --typer wtype --files emojis",
}

return programs
