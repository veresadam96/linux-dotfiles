#!/usr/bin/env bash

keys="hu";
timezone="Europe/Budapest";
user="vadam";
hostname="workstation.home";

packages() {
	#enable multilib repo
	line=$(grep -nE "\[multilib\]" /etc/pacman.conf | awk -F: '{ print $1 }');
	sed -i "${line}s/#//g" /etc/pacman.conf;
	sed -i "$((line+1))s/#//g" /etc/pacman.conf;

	#update keyring (in case the iso is too old)
	pacman --noconfirm -Sy archlinux-keyring;
	pacman --noconfirm -Syu;

	#other packages
	packages=();
	#kernel
	packages+=("base-devel" "linux-lts");
	#utilities
	packages+=("sudo" "ripgrep" "fd" "zip" "unzip" "unrar" "fzf" "bat" "fastfetch" "fuse" "atool" "tmux" "usbutils" "jq" "htop" "libinput" "libinput-tools" "fwupd" "innoextract" "binwalk");
	#CD/DVD
	packages+=("cdrtools" "cdrdao" "libcdio" "libdvdread" "libdvdcss" "libdvdnav");
	#manual
	packages+=("man-db" "man-pages");
	#kernel booter
	packages+=("grub" "efibootmgr");
	#intel cpu microcode updates
	packages+=("intel-ucode");
	#text editors
	packages+=("neovim" "vim" "vi");
	#internet
	packages+=("iwd" "dhcpcd" "openvpn" "openssh" "sshfs" "traceroute" "wget" "impala" "openresolv" "samba");
	#audio
	packages+=("pipewire" "pipewire-alsa" "pipewire-pulse" "pipewire-jack" "wireplumber" "pavucontrol" "mpd-mpris");
	#screen
	packages+=("brightnessctl" "grim" "slurp" "gammastep");
	#bluetooth
	packages+=("bluez" "bluez-utils");
	#terminal emulators
	packages+=("foot" "putty");
	#pacman support
	packages+=("reflector" "pacman-contrib");
	#dm/wm
	packages+=("polkit" "sway" "swayidle" "swaybg" "swaylock" "i3blocks" "wl-clipboard" "xorg-xwayland" "fuzzel");
	#notificaions
	packages+=("mako");
	#OpenGL/Vulkan
	packages+=("mesa" "mesa-utils" "vulkan-intel" "vulkan-tools");
	#file managers
	packages+=("nnn");
	#file system managers
	packages+=("udisks2");
	#browsers
	packages+=("firefox" "chromium");
	#fonts
	packages+=("ttf-font-awesome" "ttf-roboto" "noto-fonts" "noto-fonts-emoji" "noto-fonts-extra" "noto-fonts-cjk" "ttf-nerd-fonts-symbols" "ttf-nerd-fonts-symbols-mono" "ttf-jetbrains-mono" "ttf-liberation");
	#dev-general
	packages+=("docker" "docker-compose");
	#dev-build
	packages+=("make" "ninja" "meson");
	#dev-linters
	packages+=("markdownlint");
	#dev-vcs
	packages+=("git" "lazygit" "subversion");
	#dev-python
	packages+=("python" "python-pip" "python-lsp-server" "python-debugpy" "python-weasyprint");
	#dev-c
	packages+=("gcc");
	#dev-bash
	packages+=("bash-language-server" "shellcheck");
	#dev-java
	packages+=("jdk-openjdk" "openjdk-src" "jdk21-openjdk" "openjdk21-src" "jdk17-openjdk" "openjdk17-src" "jdk11-openjdk" "openjdk11-src" "jdk8-openjdk" "openjdk8-src" "maven" "gradle");
	#dev-web
	packages+=("npm" "vscode-html-languageserver" "vscode-css-languageserver" "typescript" "typescript-language-server" "eslint" "eslint-language-server");
	#dev-lua
	packages+=("lua-language-server");
	#dev-sql
	packages+=("dbeaver");
	#dev-games
	packages+=("godot");
	#passwords
	packages+=("pass");
	#multimedia
	packages+=("swayimg" "mpv" "mpc" "mpd" "pdfjs" "imagemagick" "yt-dlp" "ffmpeg" "gimp");
	#ios
	packages+=("libimobiledevice" "usbmuxd" "ifuse");
	#office
	packages+=("libreoffice-fresh");
	#qt
	packages+=("qt6-base" "qt6-wayland");
	#gtk
	packages+=("gtk3" "gtk4" "gnome-themes-extra" "zenity");
	#rdp
	packages+=("freerdp");
	#vm
	packages+=("qemu-full");
	#freedesktop/xdg
	packages+=("xdg-utils" "xdg-user-dirs" "xdg-desktop-portal-wlr" "xdg-desktop-portal-gtk");
	#gaming
	packages+=("lutris" "wine" "winetricks");
	#libs
	packages+=("libbsd" "lib32-mesa" "lib32-mesa-utils" "lib32-vulkan-intel" "libsixel" "libnotify" "lib32-libpulse" "lib32-gnutls");
	#torrent
	packages+=("transmission-gtk");
	#printer
	#packages+=("cups" "hplip");

	if ! pacman --noconfirm -Syu "${packages[@]}"; then
		exit 1;
	fi
}

users() {
	useradd -m -g users -N -G wheel,docker "$user";
	useradd -m -g users -N -G wheel,docker fallback_admin;

	echo "Setting password for root...";
	passwd;
	echo "Setting password for $user...";
	passwd "$user";
	echo "Setting password for fallback_admin...";
	passwd fallback_admin;
}

sudoers() {
	echo -e "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/sudoers-override
}

services() {
	systemctl enable iwd;
	systemctl enable bluetooth;
	systemctl enable dhcpcd;
	systemctl enable paccache.timer;
	systemctl enable fstrim.timer;
	systemctl enable docker;
	#systemctl enable cups;
}

timezone() {
	# set network time protocol on
	timedatectl set-ntp 1;
	# symbolic link to timezone
	ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime;
	# synchronize hardware clocks
	hwclock --systohc;
}

locale() {
	#set locales
	sed -i s/#hu_HU.UTF-8/hu_HU.UTF-8/g /etc/locale.gen;
	sed -i s/#pl_PL.UTF-8/pl_PL.UTF-8/g /etc/locale.gen;
	sed -i s/#en_US.UTF-8/en_US.UTF-8/g /etc/locale.gen;
	#generate locales from /etc/locale.gen
	locale-gen;
	#set system lang
	echo "LANG=en_US.UTF-8" >> /etc/locale.conf;
	#set system keyboard mapping
	echo "KEYMAP=$keys" >> /etc/vconsole.conf;
}

hostname() {
	echo "$hostname" >> /etc/hostname;
}

dhcpcd() {
	#disable ARP for DHCPCD -> not needed for home networks
	echo "noarp" >> /etc/dhcpcd.conf;
	#update /etc/resolv.conf
	if ! resolvconf -u; then
		echo "dhcpcd resolvconf -u: FAIL";
		exit 1;
	fi
}

#special kernel param for new lenovo ideapad: pcie_port_pm=off
grub() {
	if ! grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB; then
		echo "grub-install: FAIL";
		exit 1;
	fi

	default_linenum=$(grep -nE "^#?GRUB_DEFAULT=.*" /etc/default/grub | awk -F: '{print $1}');
	savedefault_linenum=$(grep -nE "^#?GRUB_SAVEDEFAULT=.*" /etc/default/grub | awk -F: '{print $1}');
	disable_submenu_linenum=$(grep -nE "^#?GRUB_DISABLE_SUBMENU=.*" /etc/default/grub | awk -F: '{print $1}');

	if [ -z "$default_linenum" ]; then
		echo "GRUB_DEFAULT=saved" >> /etc/default/grub;
	else
		sed -i "${default_linenum}s/#\?\(.*\)=.*/\1=saved/g" /etc/default/grub;
	fi

	if [ -z "$savedefault_linenum" ]; then
		echo "GRUB_SAVEDEFAULT=true" >> /etc/default/grub;
	else
		sed -i "${savedefault_linenum}s/#\?\(.*\)=.*/\1=true/g" /etc/default/grub;
	fi

	if [ -z "$disable_submenu_linenum" ]; then
		echo "GRUB_DISABLE_SUBMENU=y" >> /etc/default/grub;
	else
		sed -i "${disable_submenu_linenum}s/#\?\(.*\)=.*/\1=y/g" /etc/default/grub;
	fi

	if ! grub-mkconfig -o /boot/grub/grub.cfg; then
		echo "grub-mkconfig: FAIL";
		exit 1;
	fi
}

logind_conf() {
	mkdir -p /etc/systemd/logind.conf.d;
	echo -e "[Login]\nHandlePowerKey=ignore\nHandlePowerKeyLongPress=poweroff" > /etc/systemd/logind.conf.d/poweroff.conf;
}

gpg_agent_conf() {
	mkdir -p "/home/$user/.gnupg";
	echo -e "pinentry-program /usr/bin/pinentry-curses" > "/home/$user/.gnupg/gpg-agent.conf";
	chown -R "$user:users" "/home/$user/.gnupg";
}

create_trash() {
	mkdir -p "/home/$user/.local/share/Trash";
	chown -R "$user:users" "/home/$user/.local";
}

# mandatory stuff
packages;
users;
sudoers;
services;
timezone;
locale;
hostname;
dhcpcd;
grub;
logind_conf;
# optional stuff
gpg_agent_conf;
create_trash;
