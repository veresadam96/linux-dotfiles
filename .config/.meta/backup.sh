#!/usr/bin/env bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd);
escape_char=$(printf "\u1b");

gpg_recipient="veresadam96@gmail.com";
type="EXPORT";
dir="$(pwd)";
user="$USER";

import_work() {
	echo "Importing /home/$user/work...";
	if [ -f "$dir/work.tar.gz" ]; then
		mkdir -p "/home/$user/work";
		tar -xzf "$dir/work.tar.gz" -C "/home/$user/work";
		echo "	SUCCESS";
	else
		echo "	FAILED: work backup not found!";
	fi
}

import_config() {
	echo "Importing /home/$user/.config...";
	if [ -f "$dir/config.tar.gz" ]; then
		mkdir -p "/home/$user/.config";
		tar -xzf "$dir/config.tar.gz" -C "/home/$user/.config";
		#import my gpg key
		echo "Authenticating as $user...";
		su -P "$user" sh -c "gpg --import /home/$user/.config/.meta/${gpg_recipient}.gpg.key && echo -e '5\ny\n' | gpg --command-fd 0 --edit-key \$(gpg --list-keys ${gpg_recipient} | head -n2 | tail -n1 | tr -d '[:blank:]') trust";
		echo "	SUCCESS";
	else
		echo "	FAILED: .config backup not found!";
	fi
}

import_home() {
	echo "Importing /home/$user top folder...";
	if [ -f "$dir/home.tar.gz" ]; then
		tar -xzf "${dir}/home.tar.gz" -C "/home/$user";
		chown -R $(whoami) ~/.gnupg;
		find ~/.gnupg -type d -exec chmod 700 {} \;
		find ~/.gnupg -type f -exec chmod 600 {} \;
		echo "	SUCCESS";
	else
		echo "	FAILED: home backup not found!";
	fi
}

import_music() {
	echo "Importing /home/$user/music...";
	if [ -f "$dir/music.tar.gz" ]; then
		mkdir -p "/home/$user/music";
		tar -xzf "$dir/music.tar.gz" -C "/home/$user/music";
		echo "	SUCCESS";
	else
		echo "	FAILED: music backup not found!";
	fi
}

import_personal() {
	echo "Importing /home/$user/personal...";
	if [ -f "$dir/personal.tar.gz.gpg" ]; then
		mkdir -p "/home/$user/personal";
		gpg --decrypt --output "/home/$user/personal/personal.tar.gz" "$dir/personal.tar.gz.gpg";
		tar -xzf "/home/$user/personal/personal.tar.gz" -C "/home/$user/personal";
		rm -rf "/home/$user/personal/personal.tar.gz";
		echo "	SUCCESS";
	else
		echo "	FAILED: personal backup not found!";
	fi
}

import_games() {
	echo "Importing /home/$user/games/.meta";
	if [ -f "$dir/games.tar.gz" ]; then
		mkdir -p "/home/$user/games/.meta";
		tar -xzf "$dir/games.tar.gz" -C "/home/$user/games/.meta";
		echo "	SUCCESS";
	else
		echo "	FAILED: games backup not found!";
	fi
}

import_install() {
	echo "Importing /home/$user/.config/.meta/install";
	if [ -f "$dir/install.tar.gz" ]; then
		mkdir -p "/home/$user/.config/.meta/install";
		tar -xzf "$dir/install.tar.gz" -C "/home/$user/.config/.meta/install";
		echo "	SUCCESS";
	else
		echo "	FAILED: install backup not found!";
	fi
}

export_install() {
	echo "Exporting ~/.config/.meta/install...";
	tar -czf "$dir/install.tar.gz" -C ~/.config/.meta/install .;
	echo "	SUCCESS";
}

export_work() {
	echo "Exporting ~/work/.meta...";
	tar -czf "$dir/work.tar.gz" -C ~/work .meta;
	echo "	SUCCESS";
}

export_config() {
	echo "Exporting ~/.config...";
	tar -czf "$dir/config.tar.gz" -C ~/.config \
		.meta \
		calendar \
		foot \
		fuzzel \
		gammastep \
		gtk-3.0 \
		gtk-4.0 \
		i3blocks \
		mako \
		mpd \
		nnn \
		nvim \
		openvpn \
		sway \
		swayimg \
		swaynag \
		tmux \
		mimeapps.list \
		user-dirs.dirs \
		user-dirs.locale;
	echo "	SUCCESS";
}

export_home() {
	echo "Exporting user home top folder...";
	tar -czf "$dir/home.tar.gz" -C ~ \
		.password-store \
		.bashrc \
		bin;
	echo "	SUCCESS";
}

export_music() {
	echo "Exporting ~/music...";
	tar -czf "$dir/music.tar.gz" -C ~/music .;
	echo "	SUCCESS";
}

export_personal() {
	echo "Exporting ~/personal...";
	tar -czf "$HOME/personal/personal.tar.gz" -C ~/personal .;
	rm -rf personal.tar.gz.gpg;
	gpg --encrypt --recipient "$gpg_recipient" --output "$dir/personal.tar.gz.gpg" "$HOME/personal/personal.tar.gz";
	rm -rf "$HOME/personal/personal.tar.gz";
	echo "	SUCCESS";
}

export_games() {
	echo "Exporting ~/games/.meta...";
	tar -czf "$dir/games.tar.gz" -C ~/games/.meta .;
	echo "	SUCCESS";
}

selected=0;
items=("work" "config" "home" "music" "personal" "games" "install" "START");
disp=("work" "config" "home (top folder only)" "music" "personal (GPG encrypted)" "games" "install" "START");
sel=();
for i in "${!disp[@]}"; do
	if ! [ $i -eq $((${#disp[@]}-1)) ]; then
		sel+=("[ ]");
	fi
done

print() {
	echo "$type";
	echo "GPG recipient: $gpg_recipient";
	echo "------------";
	for i in "${!disp[@]}"; do
		if [ "$selected" -eq "$i" ]; then
			echo "> ${sel[$i]} ${disp[$i]}";
		else
			echo "${sel[$i]} ${disp[$i]}";
		fi
	done
	echo 
	echo "------------";
	if [ "$type" = "IMPORT" ]; then
		echo "import source directory: $dir";
	else
		echo "export output directory: $dir";
	fi
	echo "------------";
	echo "up/down: move up/down";
	echo "tab: switch import/export";
	echo "enter: select option";
	echo "q: exit";
}

import() {
	any_selected=0;
	for i in "${!items[@]}"; do
		if [ "${sel[i]}" = "[x]" ]; then
			any_selected=1;
			if [ "${items[i]}" = "work" ]; then
				import_work;
			elif [ "${items[i]}" = "config" ]; then
				import_config;
			elif [ "${items[i]}" = "home" ]; then
				import_home;
			elif [ "${items[i]}" = "music" ]; then
				import_music;
			elif [ "${items[i]}" = "personal" ]; then
				import_personal;
			elif [ "${items[i]}" = "games" ]; then
				import_games;
			elif [ "${items[i]}" = "install" ]; then
				import_install;
			fi
		fi
	done
	if [ $any_selected -eq 0 ]; then
		echo "Can't start, nothing was selected for import.";
	else
		echo "Import done.";
		sleep 3;
		exit 0;
	fi
}

export() {
	any_selected=0;
	cp ~/.config/.meta/backup.sh "$dir";
	for i in "${!items[@]}"; do
		if [ "${sel[i]}" = "[x]" ]; then
			any_selected=1;
			if [ "${items[i]}" = "work" ]; then
				export_work;
			elif [ "${items[i]}" = "config" ]; then
				export_config;
			elif [ "${items[i]}" = "home" ]; then
				export_home;
			elif [ "${items[i]}" = "music" ]; then
				export_music;
			elif [ "${items[i]}" = "personal" ]; then
				export_personal;
			elif [ "${items[i]}" = "games" ]; then
				export_games;
			elif [ "${items[i]}" = "install" ]; then
				export_install;
			fi
		fi
	done
	if [ $any_selected -eq 0 ]; then
		echo "Can't start, nothing was selected for export.";
	else
		echo "Export done.";
		sleep 3;
		exit 0;
	fi
}

while true; do
	clear;
	print;

	IFS=" ";
	read -r -n 1 option;
	if [ "$option" = "$escape_char" ]; then
		read -rsn 2 option;
		if [ "${option}" = "[A" ]; then
			if [ $selected -eq 0 ]; then
				selected=$((${#disp[@]}-1));
			else
				selected=$((selected-1));
			fi
		elif [ "${option}" = "[B" ]; then
			if [ $selected -eq $((${#disp[@]}-1)) ]; then
				selected=0;
			else
				selected=$((selected+1));
			fi
		fi
	else
		if [ "${option}" = "q" ]; then
			exit 0;
		elif [ "$option" = $'\t' ]; then
			if [ "$type" = "IMPORT" ]; then
				type="EXPORT";
			else
				type="IMPORT";
			fi
		elif [ -z "$option" ]; then
			if [ "${items[$selected]}" = "START" ]; then
				if [ "$type" = "IMPORT" ]; then
					import;
				else
					export;
				fi
			else
				tmp_sel=${sel[$selected]};
				if [ "$tmp_sel" = "[ ]" ]; then
					sel[selected]="[x]";
				else
					sel[selected]="[ ]"
				fi
			fi
		fi
	fi
done
