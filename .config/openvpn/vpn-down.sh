#!/usr/bin/env sh
script_dir=$(dirname -- "$0");

if [ -f "$script_dir"/update-resolv-conf.sh ]; then
	"$script_dir"/update-resolv-conf.sh;
fi
rm /tmp/ovpn-config;
pkill -SIGRTMIN+6 i3blocks;
