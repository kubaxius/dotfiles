-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

require("modules.devices.monitors")
require("modules.programs")
require("modules.autostart")
require("modules.environment")
require("modules.permissions")
require("modules.window-management.layout")
require("modules.appearance.decoration")
require("modules.appearance.animations")
require("modules.appearance.background")
require("modules.devices.input")
require("modules.keybindings")
require("modules.window-management.windows")
require("modules.window-management.workspaces")
