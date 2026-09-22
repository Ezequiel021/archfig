---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,latam", 
	    kb_options = "",
	    kb_variant = "",
        kb_model   = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "razer-razer-mamba-elite-1",
    accel_profile = "flat",
    sensitivity = 0.0,
})

hl.device({
    name        = "kingston-hyperx-pulsefire-raid",
    accel_profile = "flat",
    sensitivity = 0.0,
})
