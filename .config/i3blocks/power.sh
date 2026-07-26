#!/usr/bin/env sh

shutdown="";
reboot="";
logout="";
sleep="";

if command -v systemctl >/dev/null 2>&1; then
	shutdown="systemctl poweroff";
	reboot="systemctl reboot";
	logout="swaymsg exit";
	sleep="pkill swaynag && systemctl suspend";
elif command -v rc-status >/dev/null 2>&1; then
	shutdown="loginctl poweroff";
	reboot="loginctl reboot";
	logout="swaymsg exit";
	sleep="pkill swaynag && loginctl suspend";
fi

swaynag -t warning -m "what to do?" \
	-B "🔌 shutdown" "$shutdown" \
	-B "🗘 reboot" "$reboot" \
	-B "🚪 logout" "$logout" \
	-B "🌙 sleep" "$sleep" \
	-s "x none";
