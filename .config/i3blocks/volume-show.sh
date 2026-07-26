#!/usr/bin/env sh
if [ "${button:-0}" -eq 4 ]; then
	pactl set-sink-volume @DEFAULT_SINK@ +5% >/dev/null;
elif [ "${button:-0}" -eq 5 ]; then
	pactl set-sink-volume @DEFAULT_SINK@ -5% >/dev/null;
fi
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -m 1 -oE [0-9]+% | head -n 1);

if [ -z "$volume" ]; then
	sleep 5;
	volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -m 1 -oE [0-9]+% | head -n 1);
fi
echo "${volume}";
