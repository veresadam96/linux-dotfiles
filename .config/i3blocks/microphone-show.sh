#!/usr/bin/env sh

if [ "${button:-0}" -eq 4 ]; then
	pactl set-source-volume @DEFAULT_SOURCE@ +5% >/dev/null;
elif [ "${button:-0}" -eq 5 ]; then
	pactl set-source-volume @DEFAULT_SOURCE@ -5% >/dev/null;
fi
volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -m 1 -oE [0-9]+% | head -n 1);
echo "${volume}";
