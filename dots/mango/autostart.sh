#!/usr/bin/env bash
uwsm finalize

# services
app2unit -t service -s s noctalia
app2unit -t service -s s arrpc
app2unit -t service -s s hjem-impure
app2unit -t service -s b foot --server
app2unit -t service -s b stash watch
app2unit -t service -s a nm-applet
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
systemctl --user start xdg-desktop-portal.service --now
systemctl --user start xdg-desktop-portal-wlr.service --now
systemctl --user start xdg-desktop-portal-kde.service --now
