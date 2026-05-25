local terminal = "kitty"
local fileManager = terminal .. " --class float-fm -e yazi"
local menu = "TERMINAL=" .. terminal .. " fuzzel"
local viuFloat = terminal .. " --class float-viu -e viu"
local mainMod = "SUPER"
local tpd = "elan962c:00-04f3:30d0-touchpad"
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- ALT + LMB: Move a window by dragging more than 10px.
hl.bind("ALT + mouse:272", hl.dsp.window.resize(), { mouse = true }) -- ALT + LMB: Floats a window by clicking
-- To switch between windows in a floating workspace:
hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next()) -- Change focus to another window
	hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
end)
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Equal", hl.dsp.layout("colresize +0.1"))
hl.bind(mainMod .. " + Minus", hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. " + Period", hl.dsp.layout("promote"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. "  + F", hl.dsp.layout("colresize +conf"))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("ambxst brightness +10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ambxst brightness -10"), { locked = true, repeating = true })
hl.bind("SUPER + Super_L", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
-- hl.bind("SUPER + M", hl.dsp.exec_cmd("ambxst run dashboard"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("socat - UNIX-CONNECT:/tmp/quickshell_launcher"))
-- hl.bind("SUPER + V", hl.dsp.exec_cmd("socat - UNIX-CONNECT:/tmp/quickshell_clipboard"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
-- hl.bind("SUPER + M", hl.dsp.exec_cmd("socat - UNIX-CONNECT:/tmp/quickshell_wallpaper"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
-- hl.bind("SUPER + N", hl.dsp.exec_cmd("socat - UNIX-CONNECT:/tmp/quickshell_colorscheme"))
-- hl.bind("SUPER + T", hl.dsp.exec_cmd("ambxst run tmux"))
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("hyprview ipc call overview toggle"))
hl.bind("SUPER + BACKSPACE", hl.dsp.exec_cmd("ambxst run powermenu"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("ambxst run tools"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("ambxst run screenshot"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("ambxst run screenrecord"))
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("ambxst run lens"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("noctalia msg screen-lock"))
-- Switch workspaces with mainMod + [0-9] Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special:magic" }))
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
local function exec(cmd)
	return hl.dsp.exec_cmd(cmd)
end

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + SHIFT + CTRL + E", exec('loginctl terminate-user ""'))

hl.bind(mainMod .. " + grave", exec("hexecute"))

hl.bind(mainMod .. " + SHIFT + P", exec("hyprctl dispatch pin"))

hl.bind(mainMod .. " + P", exec("hyprctl dispatch fullscreenstate 1 1"))

hl.bind(mainMod .. " + SHIFT + F", exec("hyprctl dispatch fullscreenstate 1 1"))

hl.bind("ALT + TAB", exec("hyprctl dispatch cyclenext"))

hl.bind(mainMod .. " + F", exec("hyprctl dispatch layoutmsg 'colresize +conf'"))

hl.bind(mainMod .. " + RETURN", exec(terminal))

hl.bind(mainMod .. " + SHIFT + RETURN", exec(fileManager))

hl.bind(
	mainMod .. " + SHIFT + S",
	exec([[wayfreeze --hide-cursor & PID=$!; sleep .1; grim -g "$(slurp)" - | wl-copy; kill $PID]])
)

hl.bind(
	mainMod .. " + CTRL + SHIFT + S",
	exec(
		[[grim - | wl-copy | notify-send -i nix-snowflake-white "Screenshot taken" "Grim has screenshotted the full screen"]]
	)
)

hl.bind(
	"Print",
	exec(
		[[wayfreeze --hide-cursor & PID=$!; sleep .1; grim -g "$(slurp)" /tmp/screenshot.png; kill $PID ; swappy -f /tmp/screenshot.png]]
	)
)

hl.bind(
	mainMod .. " + Print",
	exec(
		[[wayfreeze --hide-cursor & PID=$!; sleep .1; grim -g "$(slurp)" /tmp/screenshot.png; kill $PID ; swappy -f /tmp/screenshot.png]]
	)
)

hl.bind(mainMod .. " + D", exec("pkill fuzzel || fuzzel"))

hl.bind(
	mainMod .. " + O",
	exec("stash list | " .. menu .. " --dmenu --prompt 'Clipboard History' | stash decode | wl-copy")
)

hl.bind(
	mainMod .. " + SHIFT + space",
	exec(
		[[fish -c 'set input (history search | fuzzel --dmenu); if test -n "$input"; footclient fish -c "$input"; end']]
	)
)

hl.bind(
	mainMod .. " + B",
	exec(
		[[fish -c 'systemctl --user (if test (systemctl --user is-active hyprsunset) = "inactive"; echo -n "start"; else; echo -n "stop"; end) hyprsunset']]
	)
)

hl.bind(mainMod .. " + SHIFT + O", exec([[fuzzel --dmenu --prompt-only "task: " | KURU_TODO_CONCAT=1 xargs todo add]]))

hl.bind(
	mainMod .. " + ALT + O",
	exec([[todo show | fuzzel --dmenu --prompt "delete: " | awk 'BEGIN {FS="|"} {print $1}' | xargs todo remove]])
)

for i = 1, 10 do
	local key = (i == 10) and "0" or tostring(i)

	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

	hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })

hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })

hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })

hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
hl.bind("switch:off:Lid Switch", exec([[hyprctl keyword monitor "eDP-1,preferred,auto,auto"]]), { locked = true })

hl.bind("switch:on:Lid Switch", exec([[hyprctl keyword monitor "eDP-1, disable"]]), { locked = true })
