#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo "missing .ovpn profile file parameter";
	exit 1;
fi

fifo=$(mktemp -u);
mkfifo "$fifo";
chmod 600 "$fifo";

if sudo echo; then
	username="M3Mfhlhej1u5Um9R";
	password=$(pass show "adam/protonmail.com/IKEv2/$username");
	echo -e "$username\n$password" > "$fifo" &
	sudo openvpn --cd ~/.config/openvpn/proton --config "$1" --auth-user-pass "$fifo" &
	ovpn_pid=$!

	sleep 1;
	rm -f "$fifo";
	wait "$ovpn_pid";
fi
