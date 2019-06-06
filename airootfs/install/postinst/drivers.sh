#!/bin/bash
read -p "What video-card do you have intel/amdgpu/nouveau [nouveau is for nvidia.] (Must type in exactly one of those three! Shift Sensitive!)" VIDEO
pacman -S networkmanager network-manager-applet dialog xf86-input-libinput xorg-server xorg-xinit mesa xf86-video-$VIDEO

echo "Enabling drivers and locales..."
localectl set-locale LANG="en_US.UTF-8"
systemctl enable NetworkManager