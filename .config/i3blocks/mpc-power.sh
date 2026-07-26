#!/usr/bin/env sh
if [ "${button:-0}" -eq 1 ]; then
	"$HOME/bin/mpd-toggle" >/dev/null;
elif [ "${button}" -eq 3 ] && [ -s ~/.config/mpd/pid ]; then
	foot "$HOME/bin/mpc-playlist-picker";
fi
echo 🎵;
echo;
if [ ! -s ~/.config/mpd/pid ]; then
	echo "#ff0000";
fi
