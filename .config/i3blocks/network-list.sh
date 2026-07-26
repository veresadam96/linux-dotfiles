#!/usr/bin/env sh

if [ "${button:-0}" -eq 1 ]; then
	foot -a i3blocks-network-list sh -c 'impala';
fi

station=$(iwctl station list | grep -oE "wlan[0-9]+");
wifiSSID=$(iwctl station "$station" show | grep "Connected network" | sed "s|Connected network||g" | sed -E "s/[ \t]*//g");

#echo 📶 "${wifiSSID}";
echo 📶;
#echo 🌐;
if [ -z "${wifiSSID}" ]; then
	echo;
	echo;
	echo "#ff3300";
fi
