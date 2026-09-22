------------------
---- MONITORS ----
------------------

-- Wiki -- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = "1.0",
})

hl.monitor({
    output = "desc:WEH WC27PX9019 0000000000001",
    mode = "1920x1080@144",
    position = "-1080x0",
    bitdepth = 10
})

hl.monitor({
    output = "desc:Samsung Electric Company T24B350",
    mode = "1920x1080@60",
    position = "0x0"
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	--mirror = "eDP-1"
})