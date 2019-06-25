#!/bin/bash

echo "Making the init, this may take a while..."
mkinitcpio -p linux

echo "Installing packages..."
sleep 5
pacman -S efibootmgr grub os-prober

FILE=/bios
if test -f "$FILE"
then
	grub-install /dev/sda
else
	echo "Installing GRUB..."
	grub-install --target=x86_64-efi --efi-directory=boot/efi --bootloader-id=BlueOS
fi
echo "Generating GRUB config...."
grub-mkconfig -o /boot/grub/grub.cfg
