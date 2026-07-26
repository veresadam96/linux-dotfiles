#!/usr/bin/env sh

batRoot=/sys/class/power_supply/BAT0;
status=$batRoot/status;
capacity=$(cat $batRoot/capacity);

statusIcon=$([ "$(cat $status)" = 'Charging' ] && echo ⚡ || echo 🔋 );

echo "${statusIcon} ${capacity}%";
echo;

[ "$capacity" -le 5 ] && echo "#ff0000";
[ "$capacity" -le 20 ] && echo "#ff8000";
