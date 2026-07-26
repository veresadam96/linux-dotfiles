#!/usr/bin/env sh
if [ -f /tmp/ovpn-config ]; then
	echo "🔒 VPN: $(cat /tmp/ovpn-config | xargs)";
	echo;
	echo "#ff8000";
fi
