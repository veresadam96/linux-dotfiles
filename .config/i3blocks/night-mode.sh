#!/usr/bin/env sh
use_current_wayland_output="$1"
button="${button:-0}"

current=$(pgrep -a -x wlsunset | awk '{ for (i = 1; i < NF; i++) if ($i == "-o") print $(i+1) }')

restart() {
	pkill -x wlsunset
	while pgrep -x wlsunset >/dev/null; do sleep 0.1; done
	[ -n "$1" ] && setsid -f wlsunset $1 -t 4500 >/dev/null 2>&1 </dev/null
}

if [ -n "$use_current_wayland_output" ]; then
	swaymsg -q seat - cursor move 0 0
	wayland_output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

	found=""
	args=""
	for o in $current; do
		if [ "$o" = "$wayland_output" ]; then
			found=1
		else
			args="$args -o $o"
		fi
	done

	if [ "$button" -eq 1 ]; then
		if [ -n "$found" ]; then
			restart "$args"
			found=""
		else
			restart "$args -o $wayland_output"
			found=1
		fi
	fi

else
	if [ "$button" -eq 1 ]; then
		if [ -n "$current" ]; then
			restart ""
			current=""
		else
			args=""
			for o in $(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name'); do
				args="$args -o $o"
			done
			restart "$args"
			current=1
		fi
	fi

fi
