#!/usr/bin/env sh

export XDG_CURRENT_DESKTOP='ubuntu:GNOME'
# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
waybar
