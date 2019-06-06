#!/bin/bash

echo "Making the init, this may take a while..."
mkinitcpio -p linux

echo "Installing packages..."
sleep 5
pacman -S efibootmgr grub os-prober
echo "Installing GRUB..."
grub-install --target=x86_64-efi --efi-directory=boot/efi --bootloader-id=BlueOS
echo "Generating GRUB config...."
grub-mkconfig -o /boot/grub/grub.cfg
