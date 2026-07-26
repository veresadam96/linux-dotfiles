#!/usr/bin/env bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd);

#init
keys="hu";
ping_address="artixlinux.org";

#partition
device="<CHANGETHIS>";
label="label: dos";
boot=",1G,L";
root=",+,L";
crypt_name="cryptroot";

init() {
	if ! loadkeys "$keys"; then
		echo "loadkeys $keys: FAIL";
		exit 1;
	fi

	#this install is BIOS/legacy-only (MBR + GRUB i386-pc); abort on UEFI
	if [ -d /sys/firmware/efi ]; then
		echo "UEFI mode: this installer is BIOS-only (disable EFI/OVMF in the VM)";
		exit 1;
	else
		echo "BIOS mode";
	fi

	if ! ping -c5 -W5 "$ping_address"; then
		echo "No internet connection!";
		exit 1;
	fi
}

partition() {
	if ! echo -e "$label\n$boot\n$root" | sfdisk "$device"; then
		echo "partition: FAIL";
		exit 1;
	fi

	echo "Waiting for the new /dev nodes to register...";
	sleep 5;

	#format
	boot_part=$(ls "$device"* | grep -E "$device.*1");
	root_part=$(ls "$device"* | grep -E "$device.*2");

	if ! mkfs.ext4 -F "$boot_part"; then
		echo "mkfs.ext4 $boot_part: FAIL";
		exit 1;
	fi

	#encrypt root partition (LUKS2) — prompts for passphrase + confirmation
	if ! cryptsetup -v luksFormat "$root_part"; then
		echo "cryptsetup luksFormat $root_part: FAIL";
		exit 1;
	fi

	#open it — prompts for the passphrase you just set
	if ! cryptsetup open "$root_part" "$crypt_name"; then
		echo "cryptsetup open $root_part: FAIL";
		exit 1;
	fi

	if ! mkfs.ext4 -F "/dev/mapper/$crypt_name"; then
		echo "mkfs.ext4 /dev/mapper/$crypt_name: FAIL";
		exit 1;
	fi

	#mount the decrypted mapper as root; /boot stays plaintext (holds kernel+initramfs)
	mount -m -o noatime "/dev/mapper/$crypt_name" /mnt \
		&& mount -m -o noatime "$boot_part" /mnt/boot || exit 1;
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

# pass the LUKS *partition* UUID to install_2.sh (needed for the kernel cmdline)
blkid -s UUID -o value "$root_part" > /mnt/crypt_uuid;

# pass the target disk to install_2.sh (BIOS grub-install goes to the whole disk)
echo "$device" > /mnt/boot_device;

# chroot
cp "$script_dir/install_2.sh" /mnt;
cp -r "$script_dir/cron.weekly" /mnt;
if artix-chroot /mnt sh /install_2.sh; then
	rm /mnt/install_2.sh;
	rm /mnt/crypt_uuid;
	rm /mnt/boot_device;
	rm -rf /mnt/cron.weekly;

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
