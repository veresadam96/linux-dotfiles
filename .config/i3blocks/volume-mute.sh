#!/usr/bin/env sh
if [ "${button:-0}" -eq 1 ]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle;
fi

icon=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oE "no|yes" | sed s/yes/🔈/g | sed s/no/🔊/g);
if [ -z "$icon" ]; then
	icon=🔊;
fi
echo "$icon";
