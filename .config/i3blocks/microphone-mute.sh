#!/usr/bin/env sh
if [ "${button:-0}" -eq 1 ]; then
	pactl set-source-mute @DEFAULT_SOURCE@ toggle;
fi

icon=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -oE "no|yes" | sed s/yes/🎤x/g | sed s/no/🎤/g);
echo "$icon";
