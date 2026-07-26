#!/usr/bin/env sh

install_dir="$HOME";
url="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2025.1.4.5/android-studio-2025.1.4.5-linux.tar.gz";

if [ -d "$install_dir"/android-studio ]; then
	echo "Android Studio is already installed";
	exit 0;
fi

if wget -P "$install_dir" "$url"; then
	tar -xvf "$install_dir"/android-studio*.tar.gz -C "$install_dir";
	rm -rf "$install_dir"/android-studio*.tar.gz;
fi
