#!/usr/bin/env sh
current=$(mpc current);
queue="${current:-Stopped}";
color="";
max_length=30;

if [ ! -s ~/.config/mpd/pid ]; then
    queue="OFF";
    color="#ff0000";
fi

ext_regex="\(mp3\|mp4\|wav\|avi\|opus\|webp\|webm\|m4a\)";
if [ ${#queue} -lt $max_length ]; then
    echo $(echo "${queue}" | sed "s/\.$ext_regex//g");
else
    echo $(echo "${queue}" | sed "s/\.$ext_regex//g" | cut -c 1-$max_length)...;
fi

if [ -n "${color}" ]; then
    echo;
    echo "${color}";
fi
