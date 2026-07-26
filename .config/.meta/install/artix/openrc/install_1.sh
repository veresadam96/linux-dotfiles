#!/usr/bin/env bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd);

#init
keys="hu";
ping_address="artixlinux.org";

#partition
device="<CHANGETHIS>";
label="label: gpt";
boot=",1G,U";
root=",30G,L";
var=",30G,L";
home=",+,L";

init() {
	if ! loadkeys "$keys"; then
		echo "loadkeys $keys: FAIL";
		exit 1;
	fi

	if [ "$(cat /sys/firmware/efi/fw_platform_size)" = "64" ]; then
		echo "UEFI mode";
	else
		echo "BIOS mode";
	fi

	if ! ping -c5 -W5 "$ping_address"; then
		echo "No internet connection!";
		exit 1;
	fi
}

partition() {
	if ! echo -e "$label\n$boot\n$root\n$var\n$home" | sfdisk "$device"; then
		echo "partition: FAIL";
		exit 1;
	fi

	echo "Waiting for the new /dev nodes to register...";
	sleep 5;

	#format
	boot_part=$(ls "$device"* | grep -E "$device.*1");
	root_part=$(ls "$device"* | grep -E "$device.*2");
	var_part=$(ls "$device"* | grep -E "$device.*3");
	home_part=$(ls "$device"* | grep -E "$device.*4");

	if ! mkfs.fat -F 32 "$boot_part"; then
		echo "mkfs.fat $boot_part: FAIL";
		exit 1;
	fi

	if ! mkfs.ext4 -F "$root_part"; then
		echo "mkfs.ext4 $root_part: FAIL";
		exit 1;
	fi

	if ! mkfs.ext4 -F "$var_part"; then
		echo "mkfs.ext4 $var_part: FAIL";
		exit 1;
	fi

	if ! mkfs.ext4 -F "$home_part"; then
		echo "mkfs.ext4 $home_part: FAIL";
		exit 1;
	fi

	#mount
	mount -m -o noatime "$root_part" /mnt \
		&& mount -m -o noatime "$boot_part" /mnt/boot \
		&& mount -m -o noatime "$var_part" /mnt/var \
		&& mount -m -o noatime "$home_part" /mnt/home || exit 1;
}

base_packages() {
	basestrap /mnt base openrc elogind-openrc linux linux-firmware;
}

fstab() {
	if ! fstabgen -U /mnt >> /mnt/etc/fstab; then
		echo "fstabgen: FAIL";
		exit 1;
	fi
}

# base install
init;
partition;
base_packages;
fstab;

# chroot
cp "$script_dir/install_2.sh" /mnt;
cp -r "$script_dir/cron.weekly" /mnt;
cp -r "$script_dir/init.d" /mnt;
if artix-chroot /mnt sh /install_2.sh; then
	rm /mnt/install_2.sh;
	rm -rf /mnt/cron.weekly;
	rm -rf /mnt/init.d;

	echo "################################################################";
	echo "################################################################";
	echo "################################################################";
	echo "################################################################";
	echo "________________________________________________________________";
	echo "DONT FORGET TO IMPORT THE CONFIG FILES TOO!!! USE BACKUP.SH";
	echo "________________________________________________________________";
	echo "################################################################";
	echo "################################################################";
	echo "################################################################";
	echo "################################################################";
fi
