#!/usr/bin/env bash

id="0:1:Power_Button";
layout=$(swaymsg -r -t get_inputs \
	| jq -r ".[] | select(.identifier == \"$id\") | .xkb_active_layout_name" \
	| tr '[:upper:]' '[:lower:]'
);

if [[ "$layout" == hun* ]]; then
	echo "HU";
elif [[ "$layout" == pol* ]]; then
	echo "PL";
elif [[ "$layout" =~ en.*us ]]; then
	echo "EN(US)";
else
	echo "$layout";
fi
