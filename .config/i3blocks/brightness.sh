#!/usr/bin/env sh

if [ "${button:-0}" -eq 4 ]; then
	brightnessctl set 5%+ >/dev/null;
elif [ "$button" -eq 5 ]; then
	brightnessctl set 5%- >/dev/null;
fi
echo "🔆 $(brightnessctl | grep -m 1 -oE [0-9]+% | head -n 1)";
