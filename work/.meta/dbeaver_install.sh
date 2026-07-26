#!/usr/bin/env sh

install_dir="$HOME";
url="https://github.com/dbeaver/dbeaver/releases/download/23.3.5/dbeaver-ce-23.3.5-linux.gtk.x86_64.tar.gz";

if [ -d "$install_dir"/dbeaver ]; then
	echo "DBeaver is already installed";
	exit 0;
fi

if wget -P "$install_dir" "$url"; then
	tar -xvf "$install_dir"/dbeaver*.tar.gz -C "$install_dir";
	rm -rf "$install_dir"/dbeaver*.tar.gz;
fi
