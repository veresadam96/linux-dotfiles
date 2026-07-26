#!/usr/bin/env sh
icon="E";
if [ -n "$(pgrep gammastep)" ]; then
	icon="🌙";
	if [ "${button:-0}" -eq 1 ]; then
		icon="🌞";
		pkill gammastep;
	fi
else
	icon="🌞";
	if [ "$button" -eq 1 ]; then
		icon="🌙";
		gammastep >/dev/null &
	fi
fi
echo "$icon";
