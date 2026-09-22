-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function () 
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)
local defaults = require("configuration.defaults")

hl.on("hyprland.start", function()
	hl.exec_cmd(defaults.lock)
	hl.exec_cmd("waybar")
	hl.exec_cmd("udiskie --smart-tray")
	hl.exec_cmd(defaults.idle)
	hl.exec_cmd("swaybg -i ~/Pictures/wallpapers/metalheart-blue.jpg")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
