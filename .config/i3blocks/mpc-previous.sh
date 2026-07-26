#!/usr/bin/env sh

if [ "${button:-0}" -eq 1 ]; then
	$HOME/bin/mpc-previous 2>&1 >/dev/null;
fi
