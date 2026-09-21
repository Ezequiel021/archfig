-- Ezequiel's Dotfiles v2.0

require("configuration.binds")
require("configuration.autostart")
require("configuration.style")
require("configuration.permissions")
require("configuration.input")
require("configuration.rules")
require("monitors")

-- Target your specific Wacom device
hl.device({
  name = "wacom-pen-and-multitouch-sensor-pen", -- Replace with your exact device name from hyprctl
  output = "eDP-1"                     -- Replace with your target monitor (e.g., HDMI-A-1, eDP-1)
})

