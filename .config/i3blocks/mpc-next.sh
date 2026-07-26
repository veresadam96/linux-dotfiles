#!/usr/bin/env sh

if [ "${button:-0}" -eq 1 ]; then
	$HOME/bin/mpc-next >/dev/null 2>&1;
fi
