---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("modules.programs")
local uwsm = require("modules.uwsm")
local terminal = programs.terminal
local fileManager = programs.fileManager
local menu = programs.menu
local browser = programs.browser
local emojis = programs.emojis

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local bindMod = mainMod

local function modBind(keys)
	if bindMod == "" then
		return keys
	end

	return bindMod .. " + " .. keys
end

-- bindBlocks are sets of keybindings that can be reused in multiple submaps.
local bindBlocks = {}

local function defineBindBlock(name, callback)
	bindBlocks[name] = callback
end

local function useBindBlock(name)
	local block = bindBlocks[name]

	if not block then
		error("Unknown bind block: " .. name)
	end

	block()
end

local function useBindBlocks(blocks)
	for _, block in ipairs(blocks or {}) do
		if type(block) == "function" then
			block()
		else
			useBindBlock(block)
		end
	end
end

local function defineSubmap(name, blocks, resetTo, callback)
	if type(blocks) == "function" then
		callback = blocks
		blocks = {}
	elseif type(blocks) == "string" and type(resetTo) == "function" then
		callback = resetTo
		resetTo = blocks
		blocks = {}
	elseif type(resetTo) == "function" and callback == nil then
		callback = resetTo
		resetTo = nil
	end

	blocks = blocks or {}
	callback = callback or function() end

	local function defineBinds()
		useBindBlocks(blocks)
		callback()
	end

	if resetTo then
		return hl.define_submap(name, resetTo, defineBinds)
	end

	return hl.define_submap(name, defineBinds)
end

-- Universal bind to choose or reset submaps from anywhere.
hl.bind(
	mainMod .. " + SHIFT + escape",
	uwsm.raw("~/.config/hypr/scripts/hypr-submap-menu"),
	{ submap_universal = true }
)

---------------------------
---- KEYBINDING BLOCKS ----
---------------------------

defineBindBlock("launchers", function()
	hl.bind(modBind("Q"), uwsm.exec(terminal))
	hl.bind(modBind("M"), uwsm.stop())
	hl.bind(modBind("E"), uwsm.exec(fileManager))
	hl.bind(modBind("R"), uwsm.exec(menu))
	hl.bind(modBind("period"), uwsm.exec(emojis))
end)

defineBindBlock("windows", function()
	hl.bind(modBind("C"), hl.dsp.window.close())
	hl.bind(modBind("SHIFT + C"), hl.dsp.window.kill())
	hl.bind(modBind("SHIFT + F"), hl.dsp.window.float({ action = "toggle" }))
	hl.bind(modBind("F"), uwsm.raw([[hyprctl dispatch 'hl.dsp.window.fullscreen({"fullscreen", "toggle"})']]))
	-- TODO: Make this work
	-- hl.bind(modBind("SHIFT + P"), uwsm.raw("~/.config/hypr/scripts/hypr-make-pip"))
	hl.bind(modBind("P"), hl.dsp.window.pseudo())
	hl.bind(modBind("J"), hl.dsp.layout("togglesplit")) -- dwindle only
end)

defineBindBlock("focus", function()
	hl.bind(modBind("left"), hl.dsp.focus({ direction = "left" }))
	hl.bind(modBind("right"), hl.dsp.focus({ direction = "right" }))
	hl.bind(modBind("up"), hl.dsp.focus({ direction = "up" }))
	hl.bind(modBind("down"), hl.dsp.focus({ direction = "down" }))
end)

defineBindBlock("numbered-workspaces", function()
	for i = 1, 10 do
		local key = i % 10 -- 10 maps to key 0
		hl.bind(modBind(tostring(key)), hl.dsp.focus({ workspace = i }))
		hl.bind(modBind("SHIFT + " .. key), hl.dsp.window.move({ workspace = i }))
	end
end)

defineBindBlock("special-workspace", function()
	hl.bind(modBind("S"), hl.dsp.workspace.toggle_special("magic"))
	hl.bind(modBind("SHIFT + S"), hl.dsp.window.move({ workspace = "special:magic" }))
end)

defineBindBlock("workspace-scroll", function()
	hl.bind(modBind("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
	hl.bind(modBind("mouse_up"), hl.dsp.focus({ workspace = "e-1" }))
	hl.bind("F19", hl.dsp.focus({ workspace = "e-1" }))
	hl.bind("XF86TouchpadToggle", hl.dsp.focus({ workspace = "e+1" }))
end)

defineBindBlock("macro-keys", function()
	hl.bind("XF86Tools", uwsm.raw("~/.config/hypr/scripts/hypr-submap-menu"))
	hl.bind("XF86Launch7", uwsm.exec(fileManager))
	hl.bind("XF86Launch8", uwsm.exec(terminal))
	hl.bind("XF86Launch9", uwsm.exec(menu))
end)

defineBindBlock("mouse-controls", function()
	hl.bind(modBind("mouse:272"), hl.dsp.window.drag(), { mouse = true })
	hl.bind(modBind("mouse:273"), hl.dsp.window.resize(), { mouse = true })
end)

defineBindBlock("media", function()
	hl.bind(
		"XF86AudioRaiseVolume",
		uwsm.raw("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioLowerVolume",
		uwsm.raw("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioMute",
		uwsm.raw("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86AudioMicMute",
		uwsm.raw("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86MonBrightnessUp",
		uwsm.raw("brightnessctl -e4 -n2 set 5%+"),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86MonBrightnessDown",
		uwsm.raw("brightnessctl -e4 -n2 set 5%-"),
		{ locked = true, repeating = true }
	)
	hl.bind("XF86AudioNext", uwsm.raw("playerctl next"), { locked = true })
	hl.bind("XF86AudioPause", uwsm.raw("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioPlay", uwsm.raw("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioPrev", uwsm.raw("playerctl previous"), { locked = true })
end)

defineBindBlock("screenshots", function()
	hl.bind("print", uwsm.raw("hyprshot -m region --raw | satty --filename -"), { locked = true })
	hl.bind("SHIFT + print", uwsm.raw("hyprshot -m window"))
end)

defineBindBlock("hypr-tools", function()
	hl.bind(modBind("SHIFT + I"), uwsm.raw("hypr-copy-active-window-info"))
end)

defineBindBlock("clipboard", function()
	hl.bind(modBind("V"), uwsm.raw("~/.config/hypr/scripts/cliphist-copy"))
end)
defineBindBlock("rimworld-mouse", function()
	hl.bind("1", hl.dsp.send_shortcut({ mods = "", key = "F1" }), { device = { list = { "naga" } } })
	hl.bind("2", hl.dsp.send_shortcut({ mods = "", key = "F2" }), { device = { list = { "naga" } } })
	hl.bind("3", hl.dsp.send_shortcut({ mods = "", key = "F3" }), { device = { list = { "naga" } } })
	hl.bind("5", hl.dsp.send_shortcut({ mods = "", key = "mouse:274" }), { device = { list = { "naga" } } })
	hl.bind(
		"mouse:274",
		hl.dsp.send_shortcut({ mods = "", key = "KP_Subtract" }),
		{ mouse = true, device = { list = { "naga" } } }
	)
end)

local universalBindBlocks = {
	"launchers",
	"windows",
	"focus",
	"numbered-workspaces",
	"special-workspace",
	"workspace-scroll",
	"macro-keys",
	"mouse-controls",
	"media",
	"screenshots",
	"hypr-tools",
	"clipboard",
}

useBindBlocks(universalBindBlocks)

defineSubmap("RimWorld", {
	function()
		useBindBlocks(universalBindBlocks)
	end,
	"rimworld-mouse",
})
