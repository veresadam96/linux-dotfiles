#!/usr/bin/env sh
pactl subscribe \
| grep --line-buffered -E "(sink|source) " \
| while read line; do
	type=$(echo "$line" | awk -F ' ' '{print $2}');
	if [ "$type" = "'change'" ]; then
		pkill -SIGRTMIN+2 i3blocks;
	elif [ "$type" = "'new'" ] || [ "$type" = "'remove'" ]; then
		pkill -SIGRTMIN+2 i3blocks;
		pkill -SIGRTMIN+5 i3blocks;
	fi
done
