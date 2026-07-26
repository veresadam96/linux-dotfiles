#!/usr/bin/env sh

if [ "${button:-0}" -eq 1 ]; then
	$HOME/bin/mpc-play-pause 2>&1 >/dev/null;
fi

state=$(mpc status %state%);
if [ "${state}" = "playing" ]; then
	echo "⏸";
else
	echo "▶";
fi
