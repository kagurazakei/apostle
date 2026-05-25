-- Ambxst
loadfile(os.getenv("HOME") .. "/.local/share/ambxst/hyprland.lua")()

-- OVERRIDES
-- Down here you can write or source anything that you want to override from Ambxst's settings.
require("hyprcolors")
require("animations.LimeFrenzy")
require("windowRules")
require("keybinds")
hl.monitor({ output = "eDP-1", mode = "2160x1440@60", position = "auto", scale = 1.0 })
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -t service foot -- --server")
	hl.exec_cmd("uwsm app -t service stash -- watch")
	hl.exec_cmd("uwsm app nm-applet")
	hl.exec_cmd("uwsm app -t service hyprview")
	hl.exec_cmd("uwsm app -t service hjem-impure")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

hl.env("GTK_THEME", "oomox-snazzy")

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 4,
		col = {
			active_border = {
				colors = {
					"rgba(243,139,168,1.0)",
					"rgba(243,139,168,1.0)",
					"rgba(219,232,151,1.0)",
					"rgba(178,231,173,1.0)",
					"rgba(120,169,255,1.0)",
					"rgba(255,171,145,1.0)",
				},
			},
			inactive_border = "rgb(272736)",
		},
		resize_on_border = true,
		allow_tearing = false,
		layout = "scrolling",
	},
	animations = { enabled = true },
	xwayland = { force_zero_scaling = true },
	group = {
		col = {},
		drag_into_group = 2,
		groupbar = { font_family = "CaskaydiaMono Nerd Font", font_size = 12, height = 16 },
	},
	decoration = {
		rounding = 20,
		rounding_power = 1.0,
		active_opacity = 0.96,
		inactive_opacity = 0.92,
		shadow = { enabled = false, range = 4, render_power = 3 },
		blur = { enabled = true, size = 2, passes = 3, vibrancy = 0.4 },
	},
	dwindle = { preserve_split = true },
	scrolling = {
		fullscreen_on_one_column = false,
		follow_focus = true,
		focus_fit_method = 1,
		direction = "right",
		follow_min_visible = 0.1,
		explicit_column_widths = "0.5, 1.0",
	},
	master = { new_status = "master" },
	misc = { force_default_wallpaper = 1, disable_hyprland_logo = true, vrr = true, session_lock_xray = true },
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_rules = "",
		kb_options = "caps:swapescape",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = { natural_scroll = true, middle_button_emulation = false },
	},
})

-- Track state in Lua (since Lua state persists in Hyprland)

hl.device({
	name = "elan962c:00-04f3:30d0-touchpad",
	enabled = true,
	natural_scroll = true,
	middle_button_emulation = false,
	tap_to_click = true,
	drag_lock = false,
	disable_while_typing = true,
})
-- Track state in Lua
local touchpadEnabled = true
local deviceName = "elan962c:00-04f3:30d0-touchpad"

-- Toggle function using setprop
local function toggleTouchpad()
	touchpadEnabled = not touchpadEnabled
	local newState = touchpadEnabled and "true" or "false"

	-- Use setprop (this works with Lua)
	hl.exec_cmd(string.format("hyprctl setprop device:%s enabled %s", deviceName, newState))

	-- Notification
	hl.exec_cmd(
		string.format("notify-send 'Touchpad %s' -i input-touchpad", touchpadEnabled and "Enabled" or "Disabled")
	)
end
hl.bind("XF86Tools", toggleTouchpad, { locked = true }, { action = "toggle" })
