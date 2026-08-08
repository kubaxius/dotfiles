---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("modules.programs")
local scripts_dir = programs.scripts_dir
local uwsm = require("lib.uwsm")
local keys = require("lib.keys")
local notify = require("lib.notify")
local submaps = require("lib.submaps")
local layoutGrid = require("modules.layout-grid")
-- clear any stale config of the bind-blocks
package.loaded["lib.bind-blocks"] = nil
local bindBlocks = require("lib.bind-blocks")

local bind = bindBlocks.bind
local defineBindBlock = bindBlocks.defineBindBlock
local useBindBlocks = bindBlocks.useBindBlocks

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local function modBind(key)
	return keys.withMod(mainMod, key)
end

local function defineSubmap(name, blocks, resetTo, callback)
	return submaps.define(name, blocks, resetTo, callback, useBindBlocks)
end

-- Universal bind to choose or reset submaps from anywhere.
bind(mainMod .. " + SHIFT + escape", uwsm.raw(scripts_dir .. "rofi-submap-menu"), { submap_universal = true })

---------------------------
---- KEYBINDING BLOCKS ----
---------------------------

defineBindBlock("launchers", function()
	bind(modBind("Q"), uwsm.exec(programs.terminal))
	bind(modBind("M"), uwsm.stop())
	bind(modBind("E"), uwsm.exec(programs.fileManager))
	bind(modBind("R"), uwsm.exec(programs.menu))
	bind(modBind("period"), uwsm.exec(programs.emojis))
end)

defineBindBlock("windows", function()
	bind(modBind("C"), hl.dsp.window.close())
	-- TODO: Replace this with a UWSM-aware stop-active-window helper:
	-- resolve the active window PID to its systemd user unit, stop that unit,
	-- and only fall back to Hyprland kill when no UWSM unit can be found.
	bind(modBind("SHIFT + C"), hl.dsp.window.kill())
	bind(modBind("SHIFT + F"), hl.dsp.window.float({ action = "toggle" }))
	bind(modBind("F"), uwsm.raw([[hyprctl dispatch 'hl.dsp.window.fullscreen({"fullscreen", "toggle"})']]))
	-- TODO: Make this work
	-- bind(modBind("SHIFT + P"), uwsm.raw(scripts_dir .. "hypr-make-pip"))
	bind(modBind("P"), hl.dsp.window.pseudo())
	bind(modBind("S"), hl.dsp.layout("swapwithmaster child ignoremaster")) -- master layout only
	bind(modBind("J"), hl.dsp.layout("togglesplit")) -- dwindle layout only
end)

defineBindBlock("focus", function()
	bind(modBind("left"), hl.dsp.focus({ direction = "left" }))
	bind(modBind("right"), hl.dsp.focus({ direction = "right" }))
	bind(modBind("up"), hl.dsp.focus({ direction = "up" }))
	bind(modBind("down"), hl.dsp.focus({ direction = "down" }))
end)

defineBindBlock("numbered-workspaces", function()
	for i = 1, 10 do
		local key = i % 10 -- 10 maps to key 0
		bind(modBind(tostring(key)), hl.dsp.focus({ workspace = i }))
		bind(modBind("SHIFT + " .. key), hl.dsp.window.move({ workspace = i }))
	end
end)

defineBindBlock("special-workspace", function()
	--bind(modBind("S"), hl.dsp.workspace.toggle_special("magic"))
	bind(modBind("SHIFT + S"), hl.dsp.window.move({ workspace = "special:magic" }))
end)

defineBindBlock("workspace-scroll", function()
	bind(modBind("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
	bind(modBind("mouse_up"), hl.dsp.focus({ workspace = "e-1" }))
	bind("F19", hl.dsp.focus({ workspace = "e-1" }))
	bind("XF86TouchpadToggle", hl.dsp.focus({ workspace = "e+1" }))
end)

defineBindBlock("macro-keys", function()
	bind("XF86Launch7", uwsm.exec(programs.fileManager))
	bind("XF86Launch8", uwsm.exec(programs.terminal))
	bind("XF86Launch9", uwsm.exec(programs.menu))
end)

defineBindBlock("mouse-controls", function()
	bind(modBind("mouse:272"), hl.dsp.window.drag(), { mouse = true })
	bind(modBind("mouse:273"), hl.dsp.window.resize(), { mouse = true })
	-- Normalize every tiled boundary on the active workspace after resizing.
	bind(modBind("mouse:273"), uwsm.raw(layoutGrid.normalize_helper), { release = true })
end)

defineBindBlock("media", function()
	bind(
		"XF86AudioRaiseVolume",
		uwsm.raw("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
		{ locked = true, repeating = true }
	)
	bind(
		"XF86AudioLowerVolume",
		uwsm.raw("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
		{ locked = true, repeating = true }
	)
	bind("XF86AudioMute", uwsm.raw("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
	bind(
		"XF86AudioMicMute",
		uwsm.raw("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
		{ locked = true, repeating = true }
	)
	bind("XF86MonBrightnessUp", uwsm.raw("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
	bind("XF86MonBrightnessDown", uwsm.raw("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
	bind("XF86AudioNext", uwsm.raw("playerctl next"), { locked = true })
	bind("XF86AudioPause", uwsm.raw("playerctl play-pause"), { locked = true })
	bind("XF86AudioPlay", uwsm.raw("playerctl play-pause"), { locked = true })
	bind("XF86AudioPrev", uwsm.raw("playerctl previous"), { locked = true })
end)

defineBindBlock("screenshots", function()
	bind("print", uwsm.raw("hyprshot -m region --raw | satty --filename -"), { locked = true })
	bind("SHIFT + print", uwsm.raw("hyprshot -m window"))
end)

defineBindBlock("hypr-tools", function()
	bind(modBind("SHIFT + I"), uwsm.raw("hypr-copy-active-window-info"))
end)

defineBindBlock("clipboard", function()
	bind(modBind("V"), uwsm.raw(scripts_dir .. "rofi-cliphist"))
end)
defineBindBlock("rimworld-mouse", function()
	bind("1", hl.dsp.send_shortcut({ mods = "", key = "F1" }), { device = { list = { "naga" } } })
	bind("2", hl.dsp.send_shortcut({ mods = "", key = "F2" }), { device = { list = { "naga" } } })
	bind("3", hl.dsp.send_shortcut({ mods = "", key = "F3" }), { device = { list = { "naga" } } })
	bind("5", hl.dsp.send_shortcut({ mods = "", key = "mouse:274" }), { device = { list = { "naga" } } })
	bind(
		"mouse:274",
		hl.dsp.send_shortcut({ mods = "", key = "KP_Subtract" }),
		{ mouse = true, device = { list = { "naga" } } }
	)
end)

defineBindBlock("numpad-workspaces", function()
	local keypadWorkspaces = {
		{ workspace = 1, key = "KP_1" },
		{ workspace = 2, key = "KP_2" },
		{ workspace = 3, key = "KP_3" },
		{ workspace = 4, key = "KP_4" },
		{ workspace = 5, key = "KP_5" },
		{ workspace = 6, key = "KP_6" },
		{ workspace = 7, key = "KP_7" },
		{ workspace = 8, key = "KP_8" },
		{ workspace = 9, key = "KP_9" },
	}

	for _, binding in ipairs(keypadWorkspaces) do
		bind(binding.key, hl.dsp.focus({ workspace = binding.workspace }))
		bind("SHIFT + " .. binding.key, hl.dsp.window.move({ workspace = binding.workspace, follow = false }))
		--bind("MOD3 + " .. binding.key, hl.dsp.window.move({ workspace = binding.workspace, follow = false }))
	end
end, {
	bind = "code:77",
	on_enable = function()
		notify.hyprland("Numpad workspace mode")
	end,
	on_disable = function()
		notify.hyprland("Numpad number mode")
	end,
	enabled = true,
})

local universalBindBlocks = {
	"launchers",
	"windows",
	"focus",
	"numbered-workspaces",
	"numpad-workspaces",
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
