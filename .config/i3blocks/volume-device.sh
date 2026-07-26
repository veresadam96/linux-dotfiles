#!/usr/bin/env sh

if [ "${button:-0}" = 1 ]; then
	pavucontrol;
fi

defaultSink=$(pactl get-default-sink);
grepRes=$(echo "${defaultSink}" | grep -E "^bluez_output.*");
if [ -n "${grepRes}" ]; then
	devid=$(echo "$defaultSink" | awk -F . '{print $2}' | sed "s|_|:|g");
	devinfo=$(bluetoothctl info "$devid");
	devname=$(echo "$devinfo" | grep "Name: " | awk -F': ' '{print $2}');
	#battery=$(echo "$devinfo" | grep "Battery Percentage" | sed "s/(\([0-9]\+\))/\1/g" | awk -F' ' '{print $4}');
	echo "(${devname})";
else
	echo "(speakers)";
fi
